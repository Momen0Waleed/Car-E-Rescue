import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicLiveLocationRepo {
  WebSocketChannel? _channel;

  Stream<dynamic> connectToTracking(int requestId) async* {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('ws://10.0.2.2:8000/ws/requests/$requestId?token=$token');

    _channel = WebSocketChannel.connect(url);

    yield* _channel!.stream.map((data) => jsonDecode(data));
  }

  void closeConnection() {
    _channel?.sink.close();
  }
}