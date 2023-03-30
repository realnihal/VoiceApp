import 'package:flutter/material.dart';

import '../../api/bank.dart';

class ProfileScreen extends StatelessWidget {
  User user;
  ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        child: Column(
          children: [
            Text(user.nickName),
            Text(user.fullName),
            Text(user.userName),
            Text(user.mobNumber),
            Text(user.upiId),
          ],
        ),
      ),
    );
  }
}
