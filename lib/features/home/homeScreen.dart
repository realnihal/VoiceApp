// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:voice_app/api/bank.dart';
import 'package:voice_app/api/tts.dart';
import 'package:voice_app/features/auth/languagueScreen.dart';
import 'package:voice_app/features/home/profileScreen.dart';
import '../../api/asr.dart';
import '../auth/loginScreen.dart';
import '../payment/Payment.dart';

class HomeScreen extends StatefulWidget {
  String username;
  String pin;
  HomeScreen({super.key, required this.username, required this.pin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;
  bool isLoading = false;
  final String _mPath = 'audio.mp4';
  List history = [];
  String output = "";
  File audiofile = File('audio.mp4');
  bool isTelugu = false;

  void initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      print('Microphone permission not granted');
    }

    await recorder.openRecorder();
  }

  checkPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isTelugu = (prefs.getString('language') == "telugu");
  }

  @override
  void initState() {
    checkPrefs();
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future record() async {
    await recorder.startRecorder(toFile: _mPath);
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    audiofile = File(path!);
    output = await asr(path: audiofile.path);
    setState(() {});
    checkcases(string: output);
  }

  void checkcases({required string}) async {
    final translator = GoogleTranslator();
    print("Is telugu check is here $isTelugu");
    if (isTelugu) {
      var translation = await translator.translate(string, to: 'en');
      string = translation.text;
      print(translation.text.toLowerCase());
    }
    RPBankAPI api = RPBankAPI();
    if (string.contains('balance')) {
      await api.checkBalance(username: widget.username);
      return;
    }
    if (string.contains('details')) {
      final User user = await api.userDetails(user: widget.username);
      await tts(
          text:
              "Here are your deatails ${user.fullName}. Your upi id is ${user.upiId}. Your account name is ${user.nickName}. Your account username is ${user.userName}. Your mobile number is ${user.mobNumber}");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ProfileScreen(user: user);
      }));
      return;
    }
    if (string.contains('history')) {
      history = await api.userHistory(user: widget.username);
      setState(() {});

      for (int i = 0; i < history.length; i++) {
        print(history[i]);
        await tts(
            text:
                "Transaction ${i + 1} ${history[i]['amount']} rupees from ${history[i]['from_user']} to ${history[i]['to_user']}");
      }
      return;
    }
    if (string.contains('transfer')) {
      await tts(text: "Please say out the reciever of the transfer");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return PaymentScreen(
            username: widget.username,
            pin: widget.pin,
          );
        }),
      );
      return;
    }
    if (string.contains('remove')) {
      await api.userRemove(user: widget.username);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/");
    } else {
      tts(text: "Please try again");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeScreenAppBar(),
              SizedBox(
                height: 0.2.sh,
                width: 1.sw,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // show current balance
                  children: [
                    Text(
                      (recorder.isRecording) ? 'Speak out your query...' : '',
                      style: GoogleFonts.poppins(
                        fontSize: 0.05.sw,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      output,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 200,
                    width: 1.sw,
                    child: Center(
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(history[index]['to-from']),
                              subtitle:
                                  Text(history[index]['amount'].toString()),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.1.sh,
              ),
              micWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void getTextfromAudio() {}

  Widget homeScreenAppBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 1.sw,
          height: 0.1.sh,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 0.06.sh,
                margin: EdgeInsets.only(left: 0.05.sw),
                child: Image.asset(
                  "assets/images/logo_illustration.png",
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showInstructionsModal(context);
                    },
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 0.03.sh,
                    ),
                  ),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 0.03.sh,
                    ),
                    // icon: Icon(Icons.book)
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          onTap: () async {
                            RPBankAPI api = RPBankAPI();
                            final user =
                                await api.userDetails(user: widget.username);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(user: user),
                              ),
                            );
                          },
                          value: 0,
                          child: const Text("My Account"),
                        ),
                        PopupMenuItem<int>(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageScreen(),
                              ),
                            );
                          },
                          value: 1,
                          child: const Text("Logout"),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        print("My account menu is selected.");
                      } else if (value == 1) {
                        print("Settings menu is selected.");
                      } else if (value == 2) {
                        print("Logout menu is selected.");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 0.01.sh,
            left: 0.05.sw,
          ),
          child: Text(
            "Welcome back!",
            style: GoogleFonts.poppins(
              fontSize: 0.06.sw,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget micWidget() {
    return SizedBox(
      width: 1.sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              if (recorder.isRecording) {
                setState(() {
                  isRecording = false;
                  isLoading = true;
                });
                await stop();
                setState(() {
                  isLoading = false;
                });
              } else {
                setState(() {
                  isRecording = true;
                });
                await record();
              }
              setState(() {});
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                (isRecording)
                    ? Image.asset(
                        "assets/images/audio_bubble.gif",
                        height: 0.25.sh,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 0.25.sh,
                      ),
                CircleAvatar(
                  radius: 0.14.sw,
                  backgroundColor: const Color(0xff1565C0),
                  child: (isLoading)
                      ? SizedBox(
                          height: 0.05.sh,
                          width: 0.05.sh,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          (isRecording) ? Icons.stop : Icons.mic,
                          size: 0.1.sw,
                          color: Colors.white,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInstructionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0.05.sw),
        topRight: Radius.circular(0.05.sw),
      )),
      builder: (BuildContext context) {
        return instructionBottomSheet();
      },
    );
  }

  Widget instructionBottomSheet() {
    return Container(
      height: 0.7.sh,
      width: 1.sw,
      margin: EdgeInsets.only(top: 0.03.sh, left: 0.05.sw, right: 0.05.sw),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 0.04.sw,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 0.05.sw,
                      ),
                    ),
                    SizedBox(
                      width: 0.03.sw,
                    ),
                    Text(
                      'Instructions',
                      style: GoogleFonts.poppins(
                        fontSize: 0.06.sw,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close,
                    size: 0.03.sh,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 0.03.sh,
            ),
            _instructionItem((isTelugu)
                ? '1. వినడం ప్రారంభించడానికి మైక్రోఫోన్ బటన్‌ను నొక్కండి.'
                : '1. Tap the microphone button to start listening.'),
            _instructionItem((isTelugu)
                ? '2. స్పష్టంగా మరియు మితమైన వేగంతో మాట్లాడండి.'
                : '2. Speak clearly and at a moderate pace.'),
            _instructionItem((isTelugu)
                ? '3. మీరు కింది ఆదేశాలను ఉపయోగించవచ్చు:'
                : '3. You can use the following commands:'),
            _instructionItem((isTelugu)
                ? '  - "బ్యాలెన్స్": ఖాతా బ్యాలెన్స్ తనిఖీ చేయండి.'
                : '  - "Balance": Check account balance.'),
            _instructionItem((isTelugu)
                ? '  - "వివరాలు": వినియోగదారు వివరాలను వీక్షించండి'
                : '  - "Details": View user details'),
            _instructionItem((isTelugu)
                ? '  - "చరిత్ర": గత 10 లావాదేవీలను చూడండి.'
                : '  - "History": look at past 10 transactions.'),
            _instructionItem((isTelugu)
                ? '  - "బదిలీ": లావాదేవీ చేయండి.'
                : '  - "Transfer": Make a transaction.'),
            _instructionItem((isTelugu)
                ? '4. వినడం ఆపడానికి మైక్రోఫోన్ బటన్‌ను మళ్లీ నొక్కండి.'
                : '4. Tap the microphone button again to stop listening.'),
          ],
        ),
      ),
    );
  }

  Widget _instructionItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.006.sh),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 0.04.sw,
        ),
      ),
    );
  }
}
