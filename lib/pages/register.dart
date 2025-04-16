import 'dart:convert';

import 'package:chatapp/pages/chatPage.dart';
import 'package:chatapp/pages/homePage.dart';
import 'package:chatapp/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../global/common.dart';
class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  bool _isFocused1 = false;
  final FocusNode _focusNode2 = FocusNode();
  bool _isFocused2 = false;
  final FocusNode _focusNode3 = FocusNode();
  bool _isFocused3 = false;

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
    _focusNode3.addListener(() {
      setState(() {
        _isFocused3 = _focusNode2.hasFocus;
      });
    });
  }

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
    });
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords must match")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('${Common.baseUrl}api/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': confirmPassword,
      }),
    );

    if (!mounted) return; // 🛑 ADD THIS after await

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
      });
      Common.userId = email;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Register Failed: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }


  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
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
                    SvgPicture.asset('assets/images/lock-svg.svg',height: 25,width: 25,color: Common.white,),
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
                    SvgPicture.asset('assets/images/lock-svg.svg',height: 25,width: 25,color: Common.white,),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        controller: confirmPasswordController,
                        focusNode: _focusNode3,
                        showCursor: _focusNode3.hasFocus,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
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
              onTap: _isLoading ? null : registerUser,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Common.send,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: Center(child: _isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),) : Text('Register',style: TextStyle(color: Common.white.withOpacity(0.8), fontSize: Common.login,fontWeight: FontWeight.w100),)),
                ),
              ),
            ),
            SizedBox(height: 5,),
            GestureDetector(
              onTap: ()=>{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()))
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white.withOpacity(0.5)), // default style
                  children: [
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Click here to login',
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
