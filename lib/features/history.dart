import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_app/api/asr.dart';
import 'package:voice_app/api/tts.dart';

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
  bool isLoading = false;
  bool isRecording = false;
  bool buttonReload = false;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  void initRecorder() async {
    setState(() {
      fromDate = DateTime(toDate.year);
    });
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

  Future<void> _showFromDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
        _fromDateController.text = picked.toString();
      });
    }
  }

  Future<void> _showToDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
        _toDateController.text = picked.toString();
      });
    }
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
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 0.1.sw,
                  top: 0.05.sh,
                ),
                width: 1.sw,
                child: Text(
                  'Transaction History',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 0.06.sw,
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
              SizedBox(height: 0.03.sh),
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
                  controller: _fromDateController,
                  onTap: () {
                    _showFromDatePicker(context);
                  },
                  readOnly: true,
                  cursorColor: Colors.black87,
                  keyboardType: TextInputType.name,
                  style: GoogleFonts.poppins(
                    fontSize: 0.04.sw,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    decorationThickness: 0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter From Date',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 0.03.sh),
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
                  controller: _toDateController,
                  onTap: () {
                    _showToDatePicker(context);
                  },
                  readOnly: true,
                  cursorColor: Colors.black87,
                  keyboardType: TextInputType.name,
                  style: GoogleFonts.poppins(
                    fontSize: 0.04.sw,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    decorationThickness: 0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter To Date',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 0.03.sh),
              Container(
                width: 1.sw,
                height: 0.05.sh,
                margin: EdgeInsets.symmetric(horizontal: 0.1.sw),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_toController.text.isNotEmpty) {
                      setState(() {
                        buttonReload = true;
                      });
                      String dateFilter =
                          "${fromDate.year}_${fromDate.month}-${fromDate.day}:00-00,${toDate.year}_${toDate.month}-${toDate.day}:00-00";

                      List<dynamic> details = await RPBankAPI().userHistory(
                        user: widget.user,
                        toUser: _toController.text,
                        dateFilter: dateFilter,
                      );
                      setState(() {
                        buttonReload = false;
                        userHistory = details;
                      });
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
                        'Get Details',
                        style: GoogleFonts.poppins(
                          fontSize: 0.042.sw,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                itemCount: userHistory.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    width: 1.sw,
                    margin: EdgeInsets.only(
                      left: 0.1.sw,
                      right: 0.1.sw,
                      top: 0.02.sh,
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
              SizedBox(
                height: 0.03.sh,
              ),
              micWidget(),
            ],
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
