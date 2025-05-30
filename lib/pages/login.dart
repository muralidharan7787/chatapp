import 'dart:convert';

import 'package:chatapp/pages/chatPage.dart';
import 'package:chatapp/pages/homePage.dart';
import 'package:chatapp/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../global/common.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  bool _isFocused1 = false;
  final FocusNode _focusNode2 = FocusNode();
  bool _isFocused2 = false;
  String? _selectedBaseUrl;
  TextEditingController _customUrlController = TextEditingController();

  void _showBaseUrlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Base URL'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text('Local Server', maxLines: 1, overflow: TextOverflow.ellipsis,),
                    value: 'http://192.168.1.11:3000/',
                    groupValue: _selectedBaseUrl,
                    onChanged: (value) {
                      setState(() {
                        _selectedBaseUrl = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Ms Azure Server', maxLines: 1, overflow: TextOverflow.ellipsis,),
                    value: 'https://chatapp-backendn-e3f8gjd7d6epbpcx.canadacentral-01.azurewebsites.net/',
                    groupValue: _selectedBaseUrl,
                    onChanged: (value) {
                      setState(() {
                        _selectedBaseUrl = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Custom URL', maxLines: 1, overflow: TextOverflow.ellipsis,),
                    value: 'custom',
                    groupValue: _selectedBaseUrl,
                    onChanged: (value) {
                      setState(() {
                        _selectedBaseUrl = value;
                      });
                    },
                  ),
                  if (_selectedBaseUrl == 'custom')
                    TextField(
                      controller: _customUrlController,
                      decoration: InputDecoration(hintText: 'Enter custom URL'),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    String finalUrl = '';
                    if (_selectedBaseUrl == 'custom') {
                      finalUrl = _customUrlController.text.trim();
                    } else {
                      finalUrl = _selectedBaseUrl ?? '';
                    }

                    if (finalUrl.isNotEmpty) {
                      Common.baseUrl = finalUrl;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Base URL set to: $finalUrl')),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        _isFocused1 = _focusNode1.hasFocus;
      });
    });
    _focusNode2.addListener(() {
      setState(() {
        _isFocused2 = _focusNode2.hasFocus;
      });
    });
  }

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse('${Common.baseUrl}api/auth/login'); // use 10.0.2.2 for Android emulator

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await Common.saveUser(emailController.text, responseData['token']);
      // Common.userId = emailController.text;
      // Common.token = responseData['token'];
      // print('token');
      // print(Common.token);
      setState(() {
        _isLoading = false;
      });
      print('Login Success: $responseData');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

      // Optionally store the token using SharedPreferences here

    } else {
      setState(() {
        _isLoading = false;
      });
      print('Login Failed: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus(); // dismiss keyboard
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Common.receive,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Row(
                  children: [
                    SizedBox(width: 25,),
                    SvgPicture.asset('assets/images/profile-svg.svg',height: 25,width: 25,color: Common.white,),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        focusNode: _focusNode1,
                        showCursor: _focusNode1.hasFocus,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Common.white.withOpacity(.5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Common.white.withOpacity(.5)),
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Common.receive,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Row(
                  children: [
                    SizedBox(width: 25,),
                    GestureDetector(
                      onDoubleTap: () {
                        _showBaseUrlDialog();
                      },
                      child: SvgPicture.asset(
                        'assets/images/lock-svg.svg',
                        height: 25,
                        width: 25,
                        color: Common.white,
                      ),
                    ),

                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        focusNode: _focusNode2,
                        showCursor: _focusNode2.hasFocus,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Common.white.withOpacity(.5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Common.white.withOpacity(.5)),
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            GestureDetector(
              onTap: _isLoading ? null : loginUser,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Common.send,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(child: _isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),) : Text('Login',style: TextStyle(color: Common.white.withOpacity(0.8), fontSize: Common.login,fontWeight: FontWeight.w100),)),
                ),
              ),
            ),
            SizedBox(height: 5,),
            GestureDetector(
              onTap: ()=>{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()))
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white.withOpacity(0.5)), // default style
                  children: [
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Click here to register',
                      style: TextStyle(color: Colors.blue.withOpacity(0.5)), // make this part blue
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
