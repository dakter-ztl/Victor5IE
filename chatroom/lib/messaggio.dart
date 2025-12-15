import 'dart:io';
import 'dart:convert';

class Client {
  late Socket socket;

  Future<void> connect(String username) async {
    try {
      // 10.0.2.2 per emulatore Android, 127.0.0.1 per desktop
      socket = await Socket.connect('127.0.0.1', 3000); 
      send(username); 

    } catch (e) {
      print('Connection error: $e');
    }
  }

  void send(String msg) {
    socket.write(utf8.encode('$msg\n'));
  }

  Stream<String> get messages =>
      socket.map((data) => utf8.decode(data).trim());

  void close() {
    socket.close();
  }
}
