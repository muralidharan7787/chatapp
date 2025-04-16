import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../global/common.dart';
import 'homePage.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => (Common.userId.isEmpty && Common.token.isEmpty) ? LoginPage() : HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset('assets/animation2.json', width: 200),
      ),
    );
  }
}
