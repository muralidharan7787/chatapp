import 'package:chatapp/pages/chatPage.dart';
import 'package:chatapp/pages/homePage.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/profile.dart';
import 'package:chatapp/pages/register.dart';
import 'package:chatapp/pages/splashScreen.dart';
import 'package:flutter/material.dart';
import 'global/common.dart';

void main() async {
  runApp(const MyApp());
  // await Common.loadUser();
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
      // home: SplashScreen(),
      home: Profile(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(const MaterialApp(home: ChatPage()));
// }
//
// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   late IO.Socket socket;
//   List<Map<String, dynamic>> messages = [];
//   TextEditingController controller = TextEditingController();
//   TextEditingController userIdController = TextEditingController();
//   TextEditingController receiverIdController = TextEditingController();
//
//   String myUserId = '';
//   String targetUserId = '';
//
//   @override
//   void initState() {
//     super.initState();
//     connectToServer();
//   }
//
//   void connectToServer() {
//     socket = IO.io('http://192.168.1.11:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       print('✅ Connected to server');
//     });
//
//     socket.on('private_message', (data) {
//       setState(() {
//         messages.add({
//           'from': data['from'],
//           'message': data['message'],
//         });
//       });
//     });
//
//     socket.onDisconnect((_) => print('❌ Disconnected'));
//   }
//
//   void registerUser() {
//     if (userIdController.text.trim().isNotEmpty) {
//       myUserId = userIdController.text.trim();
//       socket.emit('register', myUserId);
//       print("Registered as $myUserId");
//     }
//   }
//
//   void loadMessages() async {
//     print("Before 1");
//     targetUserId = receiverIdController.text.trim();
//     if (myUserId.isEmpty || targetUserId.isEmpty) return;
//
//     final uri = Uri.parse('${Common.baseUrl}messages/$myUserId/$targetUserId');
//     final res = await http.get(uri);
//     print("Before");
//
//     if (res.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(res.body);
//       print(data);
//       setState(() {
//         messages = data.map((msg) => {
//           'from': msg['sender_id'],
//           'message': msg['message'],
//         }).toList();
//       });
//     }
//   }
//
//   void sendMessage() {
//     String msg = controller.text.trim();
//     if (msg.isEmpty || targetUserId.isEmpty) return;
//
//     socket.emit('private_message', {
//       'from': myUserId,
//       'to': targetUserId,
//       'message': msg,
//     });
//
//     setState(() {
//       messages.add({'from': myUserId, 'message': msg});
//       controller.clear();
//     });
//   }
//
//   @override
//   void dispose() {
//     socket.dispose();
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('One-to-One Chat')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: userIdController,
//                     decoration: const InputDecoration(
//                       hintText: 'Your User ID',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(onPressed: registerUser, child: const Text('Register')),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: receiverIdController,
//                     decoration: const InputDecoration(
//                       hintText: 'Receiver ID',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(onPressed: loadMessages, child: const Text('Load Chat')),
//               ],
//             ),
//           ),
//           const Divider(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (_, index) {
//                 final msg = messages[index];
//                 final isMe = msg['from'] == myUserId;
//                 return Align(
//                   alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blue[100] : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text("${msg['from']}: ${msg['message']}"),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: sendMessage,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }