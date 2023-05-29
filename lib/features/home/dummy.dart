import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dumm"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {},
            child: const Text(
              "Click",
            ),
          ),
        ],
      ),
    );
  }
}
