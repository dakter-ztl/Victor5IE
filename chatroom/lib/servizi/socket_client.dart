import 'dart:io';
import 'dart:convert';

class SocketClient {
  Socket? _socket;

  Future<void> connect(String ip, int port, Function(String) onMessage) async {
    try {
      _socket = await Socket.connect(ip, port);

      _socket!.listen((data) {
        String message = utf8.decode(data);
        onMessage(message);
      });
    } catch (e) {
      print("Errore connessione socket: $e");
    }
  }

  void send(String text) {
    _socket?.write(text);
  }

  void close() {
    _socket?.close();
  }
}
