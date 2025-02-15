import 'dart:async';
import 'package:blood_donation_harsh_project/screen/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation _logoAnimation;
  late AnimationController _logoController;
  final FirebaseAuth appAuth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() {
    User? currentUser = appAuth.currentUser;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            currentUser == null ? AuthPage(appAuth) : const HomeScreen(),
      ),
    );
  }

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  // Widget _buildLogo() {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250.0,
              width: 250.0,
              child: Image.asset(
                "assets/logo.png",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "OneBlood",
              style: TextStyle(fontSize: 25, color: Color(0xFFa50c18)),
            ),
            Text(
              "Blood Donation App",
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
