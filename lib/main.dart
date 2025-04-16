import 'package:chatapp/pages/chatPage.dart';
import 'package:chatapp/pages/homePage.dart';
import 'package:chatapp/pages/login.dart';
import 'package:flutter/material.dart';
import 'global/common.dart' show Common;

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'mogra',
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Common.primary,
          background: Common.primary,
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Common.primary),
        scaffoldBackgroundColor: Common.primary,
      ),
      home: LoginPage(),
      // home: HomePage(),
    );
  }
}
