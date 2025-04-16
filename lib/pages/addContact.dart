import 'package:chatapp/pages/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global/common.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  // late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  // TextEditingController userIdController = TextEditingController();
  // TextEditingController receiverIdController = TextEditingController();

  String message = 'Find';
  String myUserId = '';
  String targetUserId = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
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

  void toChatPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(receiverId: targetUserId)));
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
                  ElevatedButton(onPressed: message=='Find'? isContactThere: toChatPage, child: Text(message)),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
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
}