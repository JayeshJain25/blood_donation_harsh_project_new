import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Blood Donation',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
