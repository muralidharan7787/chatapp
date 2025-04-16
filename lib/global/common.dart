import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {

  static String userId = '';
  static String sample = 'hello';
  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im11cmFsZGhhcmFuX29mZmljaWFsIiwidXNlcl9pZCI6MSwiaWF0IjoxNzQ2MDE1MTMyfQ.vw0l_MqeKm5LsnuHL5YID5_OvL121d2pMDH7wCfyts0';
  // static String baseUrl = 'https://chatapp-backendn-e3f8gjd7d6epbpcx.canadacentral-01.azurewebsites.net/';
  // static String baseUrl = 'http://localhost:3000/';
  static String baseUrl = 'http://192.168.1.9:3000/';

  static const Color primary = Color(0xFF3F3B5F);
  // static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(0xFF000000);
  // static const Color secondary = Color(0xFF535D7F);
  static const Color other1 = Color(0xFF90A0D7);
  static const Color receive = Color(0xFF535D7F);
  static const Color send = Color(0xFF868FAD);

  static const Color white = Colors.white;

  static const double h1 = 20.0;
  static const double h2 = 14.0;
  static const double h3 = 13.0;
  static const double h4 = 10.0;
  static const double login = 18.0;

  static Future<void> saveUser(String id, String tkn) async{
    final pref =  await SharedPreferences.getInstance();
    await pref.setString('userId', id);
    await pref.setString('token', tkn);
    userId = id;
    token = tkn;
  }

  static Future<void> loadUser() async{
    final pref = await SharedPreferences.getInstance();
    userId = await pref.getString('userId') ?? '';
    token = await pref.getString('token') ?? '';
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('token');
    userId = '';
    token = '';
  }
// Add more custom colors if needed
}