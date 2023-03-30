import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void setprefs(String lang) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('language', lang);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Language Selector',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your language',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 150,
            ),
            GestureDetector(
              onTap: () {
                setprefs('english');
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                height: 45,
                width: 80,
                child: const Center(child: Text('English')),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                setprefs('telugu');
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                height: 45,
                width: 80,
                child: const Center(child: Text('Telugu')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
