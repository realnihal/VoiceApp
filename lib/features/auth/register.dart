import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_app/api/bank.dart';
import 'package:voice_app/features/home/homeScreen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _mobileController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
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
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.popAndPushNamed(context, '/login');
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: 1.sh,
          width: 1.sw,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 0.1.sw,
                    top: 0.05.sh,
                  ),
                  width: 1.sw,
                  child: Text(
                    'Register',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
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
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.name,
                    controller: _fullnameController,
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
                      hintText: 'Name',
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
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
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
                      hintText: 'User Name',
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
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    keyboardType: TextInputType.phone,
                    controller: _mobileController,
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.black87,
                      ),
                      hintText: 'Phone',
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
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    controller: _pinController,
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black87,
                      ),
                      hintText: 'Pin',
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
                  child: TextFormField(
                    cursorColor: Colors.black87,
                    controller: _confirmPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    style: GoogleFonts.poppins(
                      fontSize: 0.04.sw,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black87,
                      ),
                      hintText: 'Confirm Pin',
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
                      if (_fullnameController.text.isNotEmpty &&
                          _usernameController.text.isNotEmpty &&
                          _pinController.text.isNotEmpty &&
                          _mobileController.text.isNotEmpty &&
                          _confirmPinController.text.isNotEmpty) {
                        if (_pinController.text == _confirmPinController.text) {
                          setState(() {
                            isLoading = true;
                          });
                          RPBankAPI api = RPBankAPI();
                          bool result = await api.register(
                            mobile: _mobileController.text,
                            pin: _pinController.text,
                            fullname: _fullnameController.text,
                            username: _usernameController.text,
                          );
                          if (result) {
                            if (!mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  username: _usernameController.text,
                                  pin: _pinController.text,
                                ),
                              ),
                            );
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Registration failed',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Pin and confirm pin should match',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }
                      } else {
                        if (!mounted) return;
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
                          'Register',
                          style: GoogleFonts.poppins(
                            fontSize: 0.042.sw,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.4.sh,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
