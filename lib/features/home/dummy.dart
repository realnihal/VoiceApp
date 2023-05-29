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
      "RdgwB62C8fBDsvu55Wrm+elyDaKxqUr6REzTmJ0TNOaDNfnqUZv52UC3atYGATFtTmiOBeGZLFJW7Ip7L89HHBDkipCJPKPnw0HCkQEo9MJEMFk9UX4MZ0p5FzUjzt+gSyJJu/Nw/uLf5+fC69dPAetPtjU/nY2kG6m4DZr/HeoUjAd53k75CVDdmm3Wcv6vy5T6Pr79keiRRUsxFfxbalOo2jGTuOyhDajD9tc+H3+2u4sB9WBJ3d2OrYeTZgQlG6ijnULdPzKO97FrE5y29W46FHgc+jOeRHqs8n1bMcZOUxXZsV5vRnr8r6Cv7roAGXz99p/AI+q4Ozk96wAL7BMnuhPVwtuxd6Ou/aeVhtXx5IsGLLXZ6rilVItr1y1p2qNzUABWEm8hXotToUWxQ7fxrEEnYLFz6URP00WrWGwcGYPsHQFu/KDE3a4t9NWz8o3lk7C9JFzyfzbr5T7BeSV9smQfzPKOsgbt5vANZASFS2wArYUy1dIBks84IWNdsbJP+YdVOLiG06EvN4QgnoCIRC1ZL00hiI9XAiC8C3ODWv3wUevHFUqjkC9J6+cvZgZuaDwmVKOrG+seRVwoVQSKFgoOLXlOp6yZ1OYbIS1opP63QbNPbEQpmpsCceyabnhalX9elqhBsIfWOl21qeICyWnbEbaJkcspb8gnmY8=");
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
