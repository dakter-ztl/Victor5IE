import 'package:flutter/material.dart';
import '../modelli/chat.dart';
import '../modelli/message.dart';
import '../servizi/socket_client.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  final String serverIp;

  ChatScreen({required this.chat, required this.serverIp});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketClient socket = SocketClient();
  final TextEditingController controller = TextEditingController();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    socket.connect(widget.serverIp, 3000, (msg) {
      setState(() {
        messages.add(Message(msg, false, DateTime.now()));
      });
    });
  }

  void send() {
    String text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(Message(text, true, DateTime.now()));
    });

    socket.send(text);
    controller.clear();
  }

  @override
  void dispose() {
    socket.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chat.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Container(
                  alignment:
                      msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg.isMe
                          ? Colors.green[200]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Scrivi un messaggio...",
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              IconButton(
                onPressed: send,
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
