import 'package:flutter/material.dart';
import 'chat_list_screen.dart';

class IpScreen extends StatefulWidget {
  @override
  State<IpScreen> createState() => _IpScreenState();
}

class _IpScreenState extends State<IpScreen> {
  final TextEditingController ipController = TextEditingController();

  void continueToChat() {
    String ip = ipController.text.trim();
    if (ip.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatListScreen(serverIp: ip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inserisci IP Server")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: "IP Server (es. 192.168.1.10)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: continueToChat,
              child: Text("Continua"),
            ),
          ],
        ),
      ),
    );
  }
}
