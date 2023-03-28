import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_app/api/tts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeScreenAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            width: 1.sw,
            child: Column(
              // show current balance
              children: const [
                SizedBox(height: 20),
                Text(
                  'Current Balance',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '\$ 1,000',
                  style: TextStyle(
                    fontSize: 40,
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
                  test();
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
          )
        ],
      ),
    );
  }

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              height: 30,
              width: 30,
            ),
          ),
          Text('EasyBank', style: TextStyle(color: Colors.black)),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
