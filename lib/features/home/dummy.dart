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
      "sPebAwSXunE9u950YhRsShXvXDoz+FewpnzTeNjWS3bIKLCPXFQTM2Zjkouv3a1fISQKKvACG9nj4y6crCKGNDvis8SDSLO4/QQFfUQ3ALO4HiQDcE7ZdTfD9I9paa4YTiZim6aXmoTD7t6z5yoZkU4S7OaphPgEa8YiAK0yKCyjnoQmiPP8OLrb+Wt7FJtP9qk5KvW6InFLii7kYf+WuqoPwDd9AnSRksO658e7iiKSEKqTs5ZA8QZNfYOmngBXTdD12qiICXlj/t2UYrqNPZJMMSe856kpydwOEbDTMxj5m5q7CEqmXUNEoepy9oIVCaw703ZNRl6RRbqs5ubUCf9hnBOjwuRTOBK5c/b+TYyjd2SzkXtIzpcRNg4TmUl2Kj3l9/tyLoCbDxCVCrG3eC18Bmk2yicoe9hH18sUqgLhn7EYWNeTEqX/PmzUBW1GMMz6QS96ZsZVN3seUtV1RrrIPALY+a85oZDBApL51LM/OpQSp+I+tFANE3CeOCz7lmdS3mfxxvzcfB00o5yZ/lcLWVeLIdgMB1dZ1W/4+SO54KDC8RokVpI2W5N9bXvdWGZ9NvFzQ6ojtgs7bKUtV8NfIwZbsfoSddeVuRmtjJH1PZ5wRE55bjohZ9BJATQaJXdt/ctmvZPqWkeFeBw3FNgUpgY/TE98cfOO27BZvZU=");
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
