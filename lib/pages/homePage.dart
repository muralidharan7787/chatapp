import 'package:chatapp/pages/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../global/common.dart';
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // dismiss keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            'Messages',
            style: TextStyle(
                // fontFamily: 'mogra',
                color: Common.white,
                fontSize: Common.h1
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) => ChatPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(1.0, 0.0), // Starts from right
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => ChatPage()),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 0,top: 8,bottom: 8,right: 12),
                child: SvgPicture.asset('assets/images/menu-svg.svg',height: 22,width: 22,color: Colors.white,),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            _statusList(),
            SizedBox(height: 15,),
            _searchBar(),
            SizedBox(height: 15,),
            _nameList(),
          ],
        ),
      ),
    );
  }

  Expanded _nameList() {
    return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Common.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28)// You can set any radius value
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  // SizedBox(height: 15,),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 15),
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     color: Common.primary,
                  //     borderRadius: BorderRadius.all(Radius.circular(20)),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       SizedBox(width: 20,),
                  //       Text('Search',style: TextStyle(fontSize: Common.h2,color: Common.white),),
                  //       Spacer(),
                  //       SvgPicture.asset('assets/images/search-svg.svg',color: Common.white,height: 25,width: 25,),
                  //       SizedBox(width: 15,)
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 20,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context,int index){
                        return Padding(
                          padding: EdgeInsets.only(left: 15,right: 15,top: 10),
                          child: Container(
                            height: 70,
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Common.white,
                                    shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Murali',style: TextStyle(fontSize: Common.h2,color: Common.white),),
                                    Text('Hi! How are you?',style: TextStyle(fontSize: Common.h3,color: Common.white.withOpacity(0.5)),),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: Common.white,
                                        shape: BoxShape.circle
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('08.34',style: TextStyle(fontSize: Common.h3,color: Common.white.withOpacity(0.5)),),
                                  ],
                                ),
                                SizedBox(width: 15,),
                              ],
                            ),
                          ),
                        );
                      },
                      // separatorBuilder: (context, index) {
                      //   return Center(
                      //     child: SizedBox(
                      //       width: 150,
                      //       child: Divider(
                      //         color: Common.white,
                      //         thickness: 1,
                      //       ),
                      //     ),
                      //   );
                      // },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Container _searchBar() {
    return Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          height: 45,
          decoration: BoxDecoration(
            color: Common.secondary,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              SvgPicture.asset('assets/images/search-svg.svg',color: Common.white.withOpacity(0.5),height: 20,width: 20,),
              SizedBox(width: 15,)
            ],
          ),
        );
  }

  Container _statusList() {
    return Container(
      height: 105,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            if (index==9)
              return Container(
                margin: EdgeInsets.only(right: 15),
              );
            if (index==0)
              return Container(
                margin: const EdgeInsets.only(left: 15),
                height: 105,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      height: 20,
                      width: 70,
                      alignment: Alignment.center,
                      child: Text('Your Story',style: TextStyle(fontSize: Common.h4,color: Common.white),),
                    ),
                  ],
                ),
              );
            return Container(
              margin: const EdgeInsets.only(left: 15),
              height: 105,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: 20,
                    width: 70,
                    alignment: Alignment.center,
                    child: Text('Murali',style: TextStyle(fontSize: Common.h4,color: Common.white),),
                  ),
                ],
              ),
            );
          },
        ),
    );
  }
}
