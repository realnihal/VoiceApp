import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_app/api/bank.dart';
import 'package:voice_app/api/tts.dart';

import '../../api/asr.dart';

class PaymentScreen extends StatefulWidget {
  final String username;
  final String pin;
  const PaymentScreen({super.key, required this.username, required this.pin});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final String _mPath = 'audio.mp4';
  File audiofile = File('audio.mp4');
  String output = "";
  bool isLoading = false;
  bool isRecording = false;
  bool buttonReload = false;

  void initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      print('Microphone permission not granted');
    }

    await recorder.openRecorder();
  }

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    _amountController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future record() async {
    await recorder.startRecorder(toFile: _mPath);
  }

  Future stop() async {
    setState(() {});
    final path = await recorder.stopRecorder();
    audiofile = File(path!);
    output = await asrf(path: audiofile.path);
    output = output.substring(0, output.length - 1);
    setState(() {
      _toController.text = output;
    });
    print(output);
    chosenname(output);
  }

  chosenname(String name) {
    tts(
      text:
          "you have chosen to send money to $output. If this is correct, Please enter the amount and click submit.",
    );
  }

  checkAndVerifyTransaction(
      String to, String from, String amount, String pin) async {
    setState(() {
      buttonReload = true;
    });
    RPBankAPI bank = RPBankAPI();
    try {
      final int amt = int.parse(amount);
      if (amt > 100) {
        tts(text: "You can't send more than 100 rupees at a time.");
        return;
      }
      // bank.userDetails(user: to);
      final bool outcome =
          await bank.transferMoney(amount: amt, from: from, to: to);
      if (outcome) {
        sentMoney();
      } else {
        tts(text: "Please check the user and amount and try again.");
      }
    } on Exception {
      print("User not found");
      tts(text: "Please check the user and amount and try again.");
    }
  }

  sentMoney() async {
    await tts(
      text:
          "you have sent amount of ${_amountController.text} rupees to $output. Thank you for using Voice Bank.",
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
              );
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 0.1.sw,
                    top: 0.05.sh,
                  ),
                  width: 1.sw,
                  child: Text(
                    'Payment',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 0.1.sw,
                    bottom: 0.03.sh,
                  ),
                  width: 1.sw,
                  child: Text(
                    "Press the button to start recording",
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F4FD),
                    borderRadius: BorderRadius.circular(
                      0.02.sw,
                    ),
                    border: Border.all(
                      color: const Color(0xffA9C9E8),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: 0.03.sw,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.name,
                    controller: _toController,
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter recipent name',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F4FD),
                    borderRadius: BorderRadius.circular(
                      0.02.sw,
                    ),
                    border: Border.all(
                      color: const Color(0xffA9C9E8),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: 0.03.sw,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter the amount',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Container(
                  width: 1.sw,
                  height: 0.05.sh,
                  margin: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_toController.text.isNotEmpty &&
                          _amountController.text.isNotEmpty) {
                        checkAndVerifyTransaction(
                            _toController.text,
                            widget.username,
                            _amountController.text,
                            widget.pin);
                      } else {
                        tts(text: "Enter required fields");
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Enter required fields',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1565C0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buttonReload
                            ? Row(
                                children: [
                                  SizedBox(
                                    height: 0.02.sh,
                                    width: 0.02.sh,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 0.006.sw,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.03.sw,
                                  ),
                                ],
                              )
                            : Container(),
                        Text(
                          'Make Payment',
                          style: GoogleFonts.poppins(
                            fontSize: 0.042.sw,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.2.sh,
                ),
                micWidget(),
              ],
            ),
          ),
        ),
      ),
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
}
