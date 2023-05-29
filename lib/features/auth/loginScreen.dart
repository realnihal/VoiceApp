import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_app/api/bank.dart';
import 'package:voice_app/features/auth/register.dart';
import 'package:voice_app/features/home/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          margin: EdgeInsets.only(top: 0.15.sh),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image:
                      const AssetImage("assets/images/logo_illustration.png"),
                  height: 0.6.sw,
                  width: 0.6.sw,
                ),
                SizedBox(
                  height: 0.05.sh,
                ),
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 0.03.sh,
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
                    left: 0.0.sw,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    controller: _usernameController,
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black87,
                      ),
                      hintText: 'username',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.03.sh,
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
                    left: 0.0.sw,
                  ),
                  child: TextField(
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      decorationThickness: 0,
                    ),
                    controller: _pinController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black87,
                      ),
                      hintText: 'pin',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 0.04.sw,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Container(
                  width: 1.sw,
                  height: 0.05.sh,
                  margin: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  child: ElevatedButton(
                      onPressed: () async {
                        await login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1565C0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLoading
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
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 0.042.sw,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.symmetric(
                    vertical: 0.02.sh,
                    horizontal: 0.05.sw,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 0.001.sh,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Text(
                        "Or",
                        style: GoogleFonts.poppins(
                          fontSize: 0.04.sw,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Expanded(
                        child: Container(
                          height: 0.001.sh,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.sw,
                  height: 0.05.sh,
                  margin: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1565C0),
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.3.sh,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (_usernameController.text.isNotEmpty && _pinController.text.isNotEmpty) {
      bool output = false;
      setState(() {
        isLoading = true;
      });
      RPBankAPI api = RPBankAPI();
      output = await api.login(
          pin: _pinController.text, username: _usernameController.text);

      if (output == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
                username: _usernameController.text, pin: _pinController.text),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid username or pin',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }
    } else {
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
  }
}
