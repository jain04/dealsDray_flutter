import 'package:dealsdray/Pages/Login.dart';
import 'package:dealsdray/Pages/home_screen.dart';
import 'package:dealsdray/Pages/otp_verification_screen.dart';
import 'package:dealsdray/Pages/splash_screen.dart';
import 'package:dealsdray/Pages/user_registration.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

