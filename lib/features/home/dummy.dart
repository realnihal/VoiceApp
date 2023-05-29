import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:voice_app/api/encryption.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

void decrypt() async {
  BankEncryption bankEncryption = BankEncryption();
  final output = await bankEncryption.decrypt(
      "d7KK7YzDe93FAydfLT5Meau1wkvyMi45vghDfWxOICZdpYTyeJiZI+sKinPIeXn2P3W1S+rz9Lg1+8XDzjO1m9nJTqxk8vKfYjmtq3U7eDOqcE7Ni/yEANZPh+SWO0vbnJVpIkprEjpeKUBAkZ0SoWRHjd40c6jN4bTuxz1WHUjbPl1zMtnMCGp/iuqGIws2gtIo44kb5lcW5SbsUhY5GDpG6fPt5xQ8oglDccuWmnS44K/nyw25agpWyjrSzMnnUjuNJJQLE+++2AbXgmaaGeTgMDcmp5OZf3CLxUlldBQK8GVuJyGJ55mUTYCKwZ7rrnOOU6pCo/u4uA5Wa+WVrWW/RdDD42cyXWHoXiULCM9s/EMph7A5S49XMCoJ6bvIt8CO/pIQub9HAiydgslZmnebIq1zoRjtYhMO7b/9FNH5PoudplrUvVVSazai1k6yx5dTYp0Oa3py0/BBrQUmxTMtM2gChmZkh45K7e3j67I6x+GJQa/fcByGxLYEiK9p7xqW/izGRCe2kPBtX0jFQ3oRbThLaq47ndY8Vq62iBpw58j4GQI3lrd+SUfprL0UNwKS+725nkG9Njg8+G+QG8tWSY6zgwnQBH2maaxPYsJfFwZ+LdEYdGa4M6bmumsLRXrooEXiam2+CBHmQaavdy9ywUHpuGI75PLLGvjMqd0=");
  print(output);
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dumm"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              decrypt();
            },
            child: const Text(
              "Click",
            ),
          ),
        ],
      ),
    );
  }
}
