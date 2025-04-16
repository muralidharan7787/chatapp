import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'common.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  int _connectionCount = 0;
  bool _isInitialized = false;
  final Map<String, List<Function>> _eventListeners = {};

  void initializeSocket(String userId) {
    if (!_isInitialized) {
      _socket = IO.io(
        '${Common.baseUrl}',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      _socket?.connect();
      _socket?.emit('register', userId);

      _socket?.onConnect((_) => print('✅ Connected to WebSocket'));
      _socket?.onDisconnect((_) => print('❌ Disconnected'));
      _socket?.onError((error) => print('Socket error: $error'));

      _isInitialized = true;
    }
    _connectionCount++;
  }

  IO.Socket? get socket => _socket;

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    if (!_eventListeners.containsKey(event)) {
      _eventListeners[event] = [];
      _socket?.on(event, (data) {
        for (final listener in _eventListeners[event]!) {
          listener(data);
        }
      });
    }
    _eventListeners[event]?.add(callback);
  }

  void off(String event, Function(dynamic) callback) {
    _eventListeners[event]?.remove(callback);
  }

  void dispose() {
    _connectionCount--;
    if (_connectionCount <= 0 && _socket != null) {
      for (final event in _eventListeners.keys) {
        _socket?.off(event);
      }
      _eventListeners.clear();
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
      _isInitialized = false;
      _connectionCount = 0;
    }
  }
}