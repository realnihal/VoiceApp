import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeScreenAppBar(),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 0.5.sw, child: const Text('Hello,')),
              const Text('User'),
            ],
          )
        ],
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
