import 'package:chatapp/pages/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global/common.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  // late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  String message = 'Find';
  String myUserId = '';
  String targetUserId = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    allUsers();
    // _initSocket();
    // connectToServer();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  Future<void> allUsers() async{
    try {

      final uri = Uri.parse('${Common.baseUrl}findall');
      final res = await http.get(uri);

      if (res.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Not Found")),
        );
      }

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            messages = data.map((msg) => {
              'email': msg['email'],
            }).toList();
            print(data);
            // _isLoading = false;
          });
        }

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // void connectToServer() {
  //   socket = IO.io('http://192.168.1.11:3000', <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //   });
  //
  //   socket.connect();
  //
  //   socket.onConnect((_) {
  //     print('✅ Connected to server');
  //   });
  //
  //   socket.on('private_message', (data) {
  //     setState(() {
  //       messages.add({
  //         'from': data['from'],
  //         'message': data['message'],
  //       });
  //     });
  //   });
  //
  //   socket.onDisconnect((_) => print('❌ Disconnected'));
  // }

  // void registerUser() {
  //   if (userIdController.text.trim().isNotEmpty) {
  //     myUserId = userIdController.text.trim();
  //     socket.emit('register', myUserId);
  //     print("Registered as $myUserId");
  //   }
  // }
  //
  // void loadMessages() async {
  //   print("Before 1");
  //   targetUserId = receiverIdController.text.trim();
  //   if (myUserId.isEmpty || targetUserId.isEmpty) return;
  //
  //   final uri = Uri.parse('${Common.baseUrl}messages/$myUserId/$targetUserId');
  //   final res = await http.get(uri);
  //   print("Before");
  //
  //   if (res.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(res.body);
  //     print(data);
  //     setState(() {
  //       messages = data.map((msg) => {
  //         'from': msg['sender_id'],
  //         'message': msg['message'],
  //       }).toList();
  //     });
  //   }
  // }


  Future<void> isContactThere() async{
    try {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Type the username")),
        );
        return;
      }

      targetUserId = controller.text;
      print('user id ----- ');
      print(targetUserId);

      final uri = Uri.parse('${Common.baseUrl}find/${targetUserId}');
      final res = await http.get(uri);

      if (res.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Not Found")),
        );
      }

      if (res.statusCode == 200) {
        // final List<dynamic> data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            message = 'Message';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void toChatPage(String target){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(receiverId: target)));
  }

  @override
  void dispose() {
    // socket.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/images/arrow2-svg.svg',
                height: 30,
                width: 30,
                color: Common.white,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'Add Contact',
              style: TextStyle(
                color: Common.white,
                fontSize: Common.h1,
                fontWeight: FontWeight.w100,
              ),
            ),
            // const Spacer(),
            // SvgPicture.asset(
            //   'assets/images/search-svg.svg',
            //   color: Common.white,
            //   height: 22,
            //   width: 22,
            // ),
            // const SizedBox(width: 10),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              // decoration: BoxDecoration(
              //   color: Common.receive,
              //   borderRadius: BorderRadius.all(Radius.circular(25)),
              // ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Common.receive,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: TextField(
                        controller: controller,
                        focusNode: _focusNode,
                        showCursor: _focusNode.hasFocus,
                        decoration: InputDecoration(
                          hintText: 'Search username',
                          hintStyle: TextStyle(color: Common.white.withOpacity(.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Common.white.withOpacity(.5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(onPressed: null,child: Text(message)),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          _nameList(),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: controller,
          //           decoration: const InputDecoration(
          //             hintText: 'Enter message...',
          //             border: OutlineInputBorder(),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.send),
          //         onPressed: sendMessage,
          //       )
          //     ],
          //   ),
          // ),
        ],
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
                child: messages.isEmpty
                    ? const Center(child: Text('No Users',style: TextStyle(color: Common.white),))
                // ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context,int index){
                    final msg = messages[index];
                    return Padding(
                      padding: EdgeInsets.only(left: 15,right: 15,top: 10),
                      child: GestureDetector(
                        onTap: (){

                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     transitionDuration: Duration(milliseconds: 300),
                          //     pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
                          //       receiverId: msg['sender_id']==Common.userId? msg['receiver_id']:msg['sender_id'],
                          //     ),
                          //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          //       final offsetAnimation = Tween<Offset>(
                          //         begin: const Offset(1.0, 0.0), // Starts from right
                          //         end: Offset.zero,
                          //       ).animate(animation);
                          //
                          //       return SlideTransition(
                          //         position: offsetAnimation,
                          //         child: child,
                          //       );
                          //     },
                          //   ),
                          // );
                        },

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
                                  Text(msg['email'],style: TextStyle(fontSize: Common.h2,color: Common.white),),
                                ],
                              ),
                              Spacer(),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () => toChatPage(msg['email']),
                                child: Text("Message"),
                              ),
                              const SizedBox(width: 15),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //     Container(
                              //       height: 10,
                              //       width: 10,
                              //       decoration: BoxDecoration(
                              //           color: Common.white,
                              //           shape: BoxShape.circle
                              //       ),
                              //     ),
                              //     SizedBox(height: 10,),
                              //     Text(msg['timestamp'],style: TextStyle(fontSize: Common.h3,color: Common.white.withOpacity(0.5)),),
                              //   ],
                              // ),
                              // SizedBox(width: 15,),
                            ],
                          ),
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
}