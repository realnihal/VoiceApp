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
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
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
    super.dispose();
  }

  Future record() async {
    await recorder.startRecorder(toFile: _mPath);
  }

  Future stop() async {
    setState(() {});
    final path = await recorder.stopRecorder();
    audiofile = File(path!);
    output = await asr(path: audiofile.path);
    output = output.substring(0, output.length - 1);
    setState(() {});
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
    RPBankAPI bank = RPBankAPI();
    try {
      final int amt = int.parse(amount);
      if (amt > 100) {
        tts(text: "You can't send more than 100 rupees at a time.");
        return;
      }
      bank.userDetails(user: to);
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
          "you have sent amount of ${_amountController.text} rupees to $output. Thank you for using Voice App.",
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (output == "")
                      ? "Press the button to start recording"
                      : output,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 0.8.sw,
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the amount',
                  ),
                ),
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
              const SizedBox(height: 100),
              // confirm button
              SizedBox(
                width: 0.8.sw,
                child: ElevatedButton(
                  onPressed: () {
                    checkAndVerifyTransaction(output, widget.username,
                        _amountController.text, widget.pin);
                  },
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
