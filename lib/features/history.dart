import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_app/api/asr.dart';

import '../api/bank.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key, required this.user});
  String user;
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  List<dynamic> userHistory = [];
  final String _mPath = 'audio.mp4';
  File audiofile = File('audio.mp4');
  String output = "";

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: 0.8.sw,
            child: TextField(
              controller: _toController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter the recipient',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            itemCount: userHistory.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: 1.sw,
                margin: EdgeInsets.only(
                  left: 0.05.sw,
                  right: 0.05.sw,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: userHistory[index]["amount"]
                            .toString()
                            .split("-")
                            .isEmpty
                        ? Colors.green
                        : Colors.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(0.03.sw),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 0.03.sw,
                  vertical: 0.01.sh,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "To: ${userHistory[index]["to_from"].toString()}",
                      style: GoogleFonts.poppins(),
                    ),
                    Text(
                      "Amount: ${userHistory[index]["amount"].toString()}",
                      style: GoogleFonts.poppins(),
                    ),
                    Text(
                      "Date: ${userHistory[index]["date"].toString()}",
                      style: GoogleFonts.poppins(),
                    ),
                    Text(
                      "Time: ${userHistory[index]["time"].toString()}",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
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
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 0.8.sw,
            child: ElevatedButton(
              onPressed: () async {
                List<dynamic> details = await RPBankAPI().userHistory(
                  user: widget.user,
                  toUser: _toController.text,
                );
                setState(() {
                  userHistory = details;
                });
              },
              child: const Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
