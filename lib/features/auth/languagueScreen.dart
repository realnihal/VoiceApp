import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_app/features/auth/loginScreen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void setprefs(String lang) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('language', lang);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Column(
          children: [
            Container(
              height: 0.5.sh,
              padding: EdgeInsets.symmetric(
                horizontal: 0.05.sw,
              ),
              margin: EdgeInsets.only(top: 0.05.sh),
              child: Image.asset(
                "assets/images/logo_full.png",
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Welcome",
              style: GoogleFonts.poppins(
                fontSize: 0.08.sw,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),
              ),
            ),
            Container(
              width: 1.sw,
              margin: EdgeInsets.only(top: 0.03.sh, left: 0.075.sw),
              child: Text(
                "Choose your language",
                style: GoogleFonts.poppins(
                  fontSize: 0.04.sw,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1f1d1d),
                ),
              ),
            ),
            Container(
              width: 1.sw,
              margin: EdgeInsets.only(top: 0.02.sh),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setprefs('english');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 0.4.sw,
                      width: 0.4.sw,
                      decoration: BoxDecoration(
                        color: const Color(0xffDAF5FF),
                        borderRadius: BorderRadius.circular(0.03.sw),
                      ),
                      padding: EdgeInsets.only(
                        top: 0.02.sh,
                        bottom: 0.02.sh,
                        left: 0.05.sw,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi!",
                                style: GoogleFonts.poppins(
                                  fontSize: 0.045.sw,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1f1d1d),
                                ),
                              ),
                              Text(
                                "I am Ramesh",
                                style: GoogleFonts.poppins(
                                  fontSize: 0.04.sw,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1f1d1d),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "English",
                            style: GoogleFonts.poppins(
                              fontSize: 0.035.sw,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.05.sw,
                  ),
                  GestureDetector(
                    onTap: () {
                      setprefs('telugu');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 0.4.sw,
                      width: 0.4.sw,
                      decoration: BoxDecoration(
                        color: const Color(0xffDAF5FF),
                        borderRadius: BorderRadius.circular(0.03.sw),
                      ),
                      padding: EdgeInsets.only(
                        top: 0.02.sh,
                        bottom: 0.02.sh,
                        left: 0.05.sw,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "నమస్కారం!",
                                style: GoogleFonts.poppins(
                                  fontSize: 0.04.sw,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1f1d1d),
                                ),
                              ),
                              Text(
                                "నేను రమేష్‌ని",
                                style: GoogleFonts.poppins(
                                  fontSize: 0.045.sw,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1f1d1d),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "తెలుగు",
                            style: GoogleFonts.poppins(
                              fontSize: 0.038.sw,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
