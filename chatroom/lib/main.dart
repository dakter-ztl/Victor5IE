import 'package:flutter/material.dart';
import 'messaggio.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NicknamePage(),
    );
  }
}

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  State<NicknamePage> createState() => NicknamePageState();
}

class NicknamePageState extends State<NicknamePage> {
  final TextEditingController nicknameController = TextEditingController();

  void connectAndNavigate() {
    final nickname = nicknameController.text.trim();
    if (nickname.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChatPage(nickname: nickname),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scegli Nickname')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(hintText: 'Inserisci il tuo nome'),
              onSubmitted: (_) => connectAndNavigate(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectAndNavigate,
              child: const Text('Entra in chat'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String nickname;
  const ChatPage({super.key, required this.nickname});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final Client client = Client(); 
  final TextEditingController controller = TextEditingController();
  final List<String> messages = [];

  @override
  void initState() {
    super.initState();
    client.connect(widget.nickname);

    client.messages.listen((msg) {
      setState(() {
        messages.add(msg);
      });
    });
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatroom - ${widget.nickname}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(messages[i]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: 'Scrivi messaggio'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      client.send(controller.text);
                      controller.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
