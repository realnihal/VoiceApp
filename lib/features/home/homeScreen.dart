import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_app/api/bank.dart';
import '../../api/asr.dart';
import '../auth/loginScreen.dart';

class HomeScreen extends StatefulWidget {
  String username;
  HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final String _mPath = 'audio.mp4';
  String output = "";
  File audiofile = File('audio.mp4');

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

  void checkcases({required string}) {
    RPBankAPI api = RPBankAPI();
    if (string.contains('balance')) {
      api.checkBalance(username: widget.username);
    }
    if (string.contains('details')) {
      api.userDetails(user: widget.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeScreenAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // show current balance
              children: [
                Text(
                  (recorder.isRecording) ? 'Speak out your query' : '',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
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
              GestureDetector(
                onTap: () {
                  print('tapped');
                  RPBankAPI api = RPBankAPI();
                  api.checkBalance(username: widget.username);
                },
                child: speakOutBalance(),
              ),
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
                    ]),
                height: 200,
                width: 0.5.sw,
                child: const Center(
                  child: Text(
                    'Hello',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.2.sh,
          ),
          ElevatedButton(
            onPressed: () async {
              if (recorder.isRecording) {
                await stop();
              } else {
                await record();
              }
              setState(() {});
            },
            child: Icon(
              (recorder.isRecording) ? Icons.stop : Icons.mic,
              size: 80,
            ),
          )
        ],
      ),
    );
  }

  void getTextfromAudio() {}

  Container speakOutBalance() {
    return Container(
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
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
      height: 200,
      width: 0.5.sw,
      child: const Center(
        child: Text(
          'Balance',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  AppBar homeScreenAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(2.0),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              height: 30,
              width: 30,
            ),
          ),
          const Text('EasyBank', style: TextStyle(color: Colors.black)),
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Settings"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
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
                          builder: (context) => const LoginScreen()));
                }
              }),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
