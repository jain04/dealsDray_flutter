import 'dart:async';

import 'package:dealsdray/Pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import the flutter_svg package

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logoipsum-300.svg",  // Path to your SVG file in the assets
              width: 140, // You can adjust the width and height as needed
              height: 140,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("DealsDray",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(color: Colors.blueAccent)
          ],
        ),
      ),
    );
  }
}
