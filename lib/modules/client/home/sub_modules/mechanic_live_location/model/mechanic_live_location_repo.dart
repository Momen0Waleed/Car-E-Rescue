// mechanic_live_location_repo.dart
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class MechanicLiveLocationRepo {
  WebSocketChannel? _channel;


  Stream<dynamic> connectToTracking(int requestId) async* {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    // FastAPI is sensitive to trailing slashes.
    // If the backend route is "/ws/requests/{request_id}", use NO slash.
    final String path = '/ws/requests/$requestId';

    final uri = Uri(
      scheme: 'ws',
      host: '10.0.2.2',
      port: 8000,
      path: path,
      queryParameters: {'token': token},
    );

    debugPrint("DEBUG: Connecting with Query Auth to: ${uri.toString()}");

    try {
      _channel = IOWebSocketChannel.connect(uri);

      yield* _channel!.stream.map((data) {
        debugPrint("DEBUG: Data received: $data");
        return jsonDecode(data);
      });
    } catch (e) {
      debugPrint("DEBUG: Connection Error: $e");
      rethrow;
    }
  }

  void closeConnection() {
    debugPrint("DEBUG: Closing WebSocket connection manually.");
    _channel?.sink.close();
  }
}