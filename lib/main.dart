import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_app/features/auth/register.dart';
import 'package:voice_app/features/home/dummy.dart';

import 'features/auth/languagueScreen.dart';
import 'features/auth/loginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(

        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Voice App',
            // You can use the library anywhere in the app even in theme
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018
                  .apply(fontSizeFactor: 1.sp, bodyColor: Colors.black),
            ),
            initialRoute: '/',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterPage(),
              '/': (context) => const DummyScreen(),
            },
          );
        });
  }
}
