import 'package:chatapp/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../global/common.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // dismiss keyboard
      },
      child: Scaffold(
        backgroundColor: Common.primary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => HomePage(), // replace with your screen
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1, 0), // Starts from right
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  ); // Custom back navigation
              },
              child: SvgPicture.asset('assets/images/arrow2-svg.svg',height: 30,width: 30,color: Common.white,)),
              SizedBox(width: 15,),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Common.white,
                  shape: BoxShape.circle
                ),
                // child: ,
              ),
              SizedBox(width: 15,),
              Text('Murali',style: TextStyle(color: Common.white,fontSize: Common.h1,fontWeight: FontWeight.w100),),
              Spacer(),
              SvgPicture.asset('assets/images/search-svg.svg',color: Common.white,height: 22,width: 22,),
              SizedBox(width: 10,)
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 15,),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Common.receive,
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15),topRight: Radius.circular(15),bottomRight: Radius.circular(15),),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20,),
            Row(
              children: [
                Spacer(),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Common.send,
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15),bottomRight: Radius.circular(15),topLeft: Radius.circular(15),),
                  ),
                ),
                SizedBox(width: 15,),
              ],
            ),

            Spacer(),
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
                    SizedBox(width: 15,),
                    SvgPicture.asset('assets/images/camera-svg.svg',height: 25,width: 25,color: Common.white,),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        showCursor: _focusNode.hasFocus,
                        decoration: InputDecoration(
                          hintText: 'Search',
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
                    SizedBox(width: 20,),
                    // Text('Search',style: TextStyle(fontSize: Common.h2,color: Common.white),),
                    SvgPicture.asset('assets/images/send-svg.svg',color: Common.white,height: 30,width: 30,),
                    SizedBox(width: 15,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}
