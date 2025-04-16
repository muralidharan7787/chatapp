import 'dart:async';

import 'package:chatapp/pages/addContact.dart';
import 'package:chatapp/pages/allUsers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatapp/global/socket_service.dart';
import 'package:chatapp/global/common.dart';
import 'package:chatapp/pages/chatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true; // show shimmer initially
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _tapResetTimer;
  late ConfettiController _confettiController;
  int _tapCount = 0;
  Timer? _tapTimer;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final SocketService _socketService = SocketService();
  List messages = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _focusNode.addListener(_onFocusChange);
    Future.delayed(Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _loading = false; // after 6 seconds stop shimmer
        });
      }
    });
    _initSocket();

  }

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final formattedTime = DateFormat.jm().format(dateTime); // Example: 9:15 PM
    return formattedTime;
  }

  void _handleFabTap(BuildContext context) {
    _tapCount++;
    _tapResetTimer?.cancel();

    _tapResetTimer = Timer(Duration(milliseconds: 500), () {
      if (_tapCount >= 10) {
        // 🎉 Easter egg: trigger animation and feedback
        _confettiController.play();
        Fluttertoast.showToast(
          msg: "🎊 Easter Egg Unlocked! Showing All Users!",
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllUsers()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddContact()),
        );
      }
      _tapCount = 0;
    });
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _initSocket() {
    _socketService.initializeSocket(Common.userId);

    _socketService.on('latestMessages', (data) async {
      print('LatestMesssages is called');
      // await _audioPlayer.play(AssetSource('sounds/send.mp3'));
      if (mounted) {
        setState(() {
          messages = List.from(data);
          print(messages);
        });
      }
    });

    _socketService.socket?.on('connect', (_) {
      _socketService.emit('getLatestMessages', Common.userId);
    });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // dismiss dialog
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs
                      .clear(); // or remove('userId') and remove('token') if needed

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            'Messages',
            style: TextStyle(color: Common.white, fontSize: Common.h1),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                top: 8,
                bottom: 8,
                right: 12,
              ),
              child: GestureDetector(
                onTap: () => showLogoutDialog(context),
                child: SvgPicture.asset(
                  'assets/images/menu-svg.svg',
                  height: 22,
                  width: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _statusList(),
            const SizedBox(height: 15),
            _searchBar(),
            const SizedBox(height: 15),
            _nameList(),
          ],
        ),
        floatingActionButton: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
              ),
            ),
            FloatingActionButton(
              onPressed: () => _handleFabTap(context),
              child: Icon(Icons.add),
              backgroundColor: Common.primary,
              tooltip: 'Add Contact',
            ),
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
            topRight: Radius.circular(28), // You can set any radius value
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
                child:
                    messages.isEmpty
                        ? (_loading ? ListView.builder(
                          itemCount: 6,
                          itemBuilder:
                              (_, __) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.black,
                                  highlightColor: Colors.grey.withOpacity(0.6),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 15,
                                              width: double.infinity,
                                              color: Colors.grey.withOpacity(
                                                0.6,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              height: 12,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.5,
                                              color: Colors.grey.withOpacity(
                                                0.6,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 10,
                                            width: 30,
                                            color: Colors.grey.withOpacity(0.6),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ): Center(child: Text("No messages yet!",style: TextStyle(color: Colors.white, fontSize: 16),),))

                        // ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final msg = messages[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 10,
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: Duration(milliseconds: 300),
                                      pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
                                        receiverId: msg['sender_id']==Common.userId? msg['receiver_id']:msg['sender_id'],
                                      ),
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
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              msg['sender_id'] == Common.userId
                                                  ? msg['receiver_id']
                                                  : msg['sender_id'],
                                              style: TextStyle(
                                                fontSize: Common.h2,
                                                color: Common.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8.0,
                                              ),
                                              child: Text(
                                                msg['message'],
                                                style: TextStyle(
                                                  fontSize: Common.h3,
                                                  color: Common.white
                                                      .withOpacity(0.5),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: Common.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            formatTimestamp(msg['timestamp']),
                                            style: TextStyle(
                                              fontSize: Common.h3,
                                              color: Common.white.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 15),
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
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              showCursor: _focusNode.hasFocus,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Common.white.withOpacity(.5)),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(8),
                // ),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Common.white.withOpacity(.5)),
            ),
          ),
          SizedBox(width: 20),
          // Text('Search',style: TextStyle(fontSize: Common.h2,color: Common.white),),
          SvgPicture.asset(
            'assets/images/search-svg.svg',
            color: Common.white.withOpacity(0.5),
            height: 20,
            width: 20,
          ),
          SizedBox(width: 15),
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
          if (index == 9) return Container(margin: EdgeInsets.only(right: 15));
          if (index == 0)
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
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 20,
                    width: 70,
                    alignment: Alignment.center,
                    child: Text(
                      'Your Story',
                      style: TextStyle(
                        fontSize: Common.h4,
                        color: Common.white,
                      ),
                    ),
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
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 20,
                  width: 70,
                  alignment: Alignment.center,
                  child: Text(
                    'Murali',
                    style: TextStyle(fontSize: Common.h4, color: Common.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
