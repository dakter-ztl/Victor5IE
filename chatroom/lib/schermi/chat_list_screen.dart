import 'package:flutter/material.dart';
import '/modelli/chat.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String serverIp;

  ChatListScreen({required this.serverIp});

  final List<Chat> chats = [
    Chat("1", "Chat Classe", "👥"),
    Chat("2", "Chat Gruppo", "💬"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];

          return ListTile(
            leading: CircleAvatar(child: Text(chat.avatar)),
            title: Text(chat.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chat: chat,
                    serverIp: serverIp,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
