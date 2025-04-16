import 'package:chatapp/pages/chatPage.dart';
import 'package:chatapp/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../global/common.dart';
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _focusNode1 = FocusNode();
  bool _isFocused1 = false;
  final FocusNode _focusNode2 = FocusNode();
  bool _isFocused2 = false;

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

  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
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
                        focusNode: _focusNode1,
                        showCursor: _focusNode1.hasFocus,
                        decoration: InputDecoration(
                          hintText: 'Email',
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
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Common.send,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: Center(child: Text('Login',style: TextStyle(color: Common.white.withOpacity(0.8), fontSize: Common.login,fontWeight: FontWeight.w100),)),
                ),
              ),
            ),
            SizedBox(height: 5,),
            RichText(
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
            )

          ],
        ),
      ),
    );
  }
}
