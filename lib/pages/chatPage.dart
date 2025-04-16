import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chatapp/global/socket_service.dart';
import 'package:chatapp/global/common.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:jumping_dot/jumping_dot.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  const ChatPage({super.key, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final SocketService _socketService = SocketService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String targetUserId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    targetUserId = widget.receiverId;
    _focusNode.addListener(_onFocusChange);
    _initSocket();
    _loadMessages();
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

    _socketService.on('private_message', (data) async {
      await _audioPlayer.play(AssetSource('sounds/send.mp3'));
      if (mounted) {
        setState(() {
          messages.add({
            'from': data['from'],
            'message': data['message'],
          });
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      }
    });

    _socketService.socket?.on('connect', (_) {
      _socketService.emit('getLatestMessages', Common.userId);
    });

  }

  Future<void> _loadMessages() async {
    try {
      if (Common.userId.isEmpty || targetUserId.isEmpty) return;

      final uri = Uri.parse('${Common.baseUrl}messages/${Common.userId}/${targetUserId}');
      print('hereeeeee');
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            messages = data.map((msg) => {
              'from': msg['sender_id'],
              'message': msg['message'],
            }).toList();
            _isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              }
            });
          });
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (_scrollController.hasClients) {
          //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          //   }
          // });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _sendMessage() async{
    final msg = _controller.text.trim();
    if (msg.isEmpty || targetUserId.isEmpty) return;

    await _audioPlayer.play(AssetSource('sounds/send.mp3'));

    _socketService.emit('private_message', {
      'from': Common.userId,
      'to': targetUserId,
      'message': msg,
    });

    _socketService.emit('getLatestMessages', Common.userId);

    if (mounted) {
      setState(() {
        messages.add({'from': Common.userId, 'message': msg});
        _controller.clear();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Common.primary,
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
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  color: Common.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                widget.receiverId,
                style: TextStyle(
                  color: Common.white,
                  fontSize: Common.h1,
                  fontWeight: FontWeight.w100,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                'assets/images/search-svg.svg',
                color: Common.white,
                height: 22,
                width: 22,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white, // 👈 change this to any color you like
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                padding: const EdgeInsets.only(bottom: 15),
                // reverse: true,
                itemBuilder: (_, index) {
                  if (index == messages.length) {
                    return SizedBox(height: 10); // Extra space at the end
                  }

                  final msg = messages[index];
                  final isMe = msg['from'] == Common.userId;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (isMe) SizedBox(width: 70), // Space on the LEFT for sent messages
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: isMe
                                  ? BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              )
                                  : BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(msg['message']),
                          ),
                        ),
                        if (!isMe) SizedBox(width: 70), // Space on the RIGHT for received messages
                      ],
                    ),
                  );
                },

              ),
            ),
            // SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Common.receive,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    SvgPicture.asset(
                      'assets/images/camera-svg.svg',
                      height: 25,
                      width: 25,
                      color: Common.white,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        showCursor: _focusNode.hasFocus,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Common.white.withOpacity(.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Common.white.withOpacity(.5)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: SvgPicture.asset(
                        'assets/images/send-svg.svg',
                        color: Common.white,
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}