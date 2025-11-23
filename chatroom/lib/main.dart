import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Room',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        scaffoldBackgroundColor: const Color(0xFFECE5DD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          elevation: 0,
        ),
      ),
      home: const ChatListScreen(),
    );
  }
}

// Modello per i messaggi
class Message {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.isMe,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'sender': sender,
        'timestamp': timestamp.toIso8601String(),
        'isMe': isMe,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        text: json['text'],
        sender: json['sender'],
        timestamp: DateTime.parse(json['timestamp']),
        isMe: json['isMe'],
      );
}

// Modello per le chat
class Chat {
  final String id;
  final String name;
  String lastMessage;
  DateTime lastMessageTime;
  final String avatar;
  int unreadCount;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatar,
    this.unreadCount = 0,
  });
}

// Service per gestire la persistenza dei messaggi in memoria
class MessageService {
  // Storage in memoria - i messaggi vengono mantenuti durante la sessione dell'app
  static final Map<String, List<Message>> _messageStorage = {};

  // Salva i messaggi di una chat specifica
  static void saveMessages(String chatId, List<Message> messages) {
    _messageStorage[chatId] = List.from(messages);
  }

  // Carica i messaggi di una chat specifica
  static List<Message> loadMessages(String chatId) {
    if (_messageStorage.containsKey(chatId)) {
      return List.from(_messageStorage[chatId]!);
    }
    
    // Ritorna messaggi iniziali di default solo se non ci sono messaggi salvati
    return _getDefaultMessages(chatId);
  }

  // Messaggi iniziali diversi per ogni chat
  static List<Message> _getDefaultMessages(String chatId) {
    final now = DateTime.now();
    
    switch (chatId) {
      case '1': // Gruppo Famiglia
        return [
          Message(
            id: '1',
            text: 'Buongiorno a tutti! 👋',
            sender: 'Mamma',
            timestamp: now.subtract(const Duration(hours: 2)),
            isMe: false,
          ),
          Message(
            id: '2',
            text: 'Ciao mamma! Come stai?',
            sender: 'Io',
            timestamp: now.subtract(const Duration(hours: 1, minutes: 50)),
            isMe: true,
          ),
          Message(
            id: '3',
            text: 'Tutto bene! Ci vediamo stasera per cena? 🍝',
            sender: 'Papà',
            timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
            isMe: false,
          ),
        ];
      
      case '2': // Lavoro Team
        return [
          Message(
            id: '1',
            text: 'Buongiorno team! Meeting alle 15:00 📊',
            sender: 'Marco',
            timestamp: now.subtract(const Duration(hours: 3)),
            isMe: false,
          ),
          Message(
            id: '2',
            text: 'Perfetto, ci sarò!',
            sender: 'Io',
            timestamp: now.subtract(const Duration(hours: 2, minutes: 45)),
            isMe: true,
          ),
          Message(
            id: '3',
            text: 'Ok, preparate il report per favore',
            sender: 'Sara',
            timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
            isMe: false,
          ),
        ];
      
      case '3': // Amici
        return [
          Message(
            id: '1',
            text: 'Ragazzi, cinema stasera? 🎬',
            sender: 'Luca',
            timestamp: now.subtract(const Duration(hours: 4)),
            isMe: false,
          ),
          Message(
            id: '2',
            text: 'Che bello! Che film vediamo?',
            sender: 'Io',
            timestamp: now.subtract(const Duration(hours: 3, minutes: 45)),
            isMe: true,
          ),
          Message(
            id: '3',
            text: 'Che ne dite del nuovo film Marvel?',
            sender: 'Anna',
            timestamp: now.subtract(const Duration(hours: 3, minutes: 20)),
            isMe: false,
          ),
        ];
      
      default:
        return [];
    }
  }

  // Cancella tutti i messaggi (per testing)
  static void clearAllMessages() {
    _messageStorage.clear();
  }
}

// Schermata lista chat
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Chat> chats = [
    Chat(
      id: '1',
      name: 'Gruppo Famiglia',
      lastMessage: 'Ciao a tutti!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      avatar: '👨‍👩‍👧‍👦',
      unreadCount: 3,
    ),
    Chat(
      id: '2',
      name: 'Lavoro Team',
      lastMessage: 'Riunione alle 15:00',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      avatar: '💼',
      unreadCount: 1,
    ),
    Chat(
      id: '3',
      name: 'Amici',
      lastMessage: 'Ci vediamo stasera?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      avatar: '🎉',
    ),

    Chat(id: '4',
    name: 'Dakter',
    lastMessage: 'mibun', 
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
    avatar: 'ZEB',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadLastMessages();
  }

  // Carica gli ultimi messaggi per ogni chat
  void _loadLastMessages() {
    for (var chat in chats) {
      final messages = MessageService.loadMessages(chat.id);
      if (messages.isNotEmpty) {
        setState(() {
          chat.lastMessage = messages.last.text;
          chat.lastMessageTime = messages.last.timestamp;
        });
      }
    }
  }

  // Aggiorna la lista quando si torna dalla chat
  void _onChatReturn() {
    _loadLastMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'clear') {
                MessageService.clearAllMessages();
                setState(() {
                  _loadLastMessages();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Messaggi cancellati!')),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Cancella tutti i messaggi'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chat: chat),
                ),
              );
              _onChatReturn();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF25D366),
                    child: Text(
                      chat.avatar,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(chat.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: chat.unreadCount > 0
                              ? const Color(0xFF25D366)
                              : Colors.grey[600],
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF25D366),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ore';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}

// Schermata chat
class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // Carica i messaggi salvati per questa chat specifica
  void _loadMessages() {
    setState(() {
      _messages = MessageService.loadMessages(widget.chat.id);
    });
    
    // Scroll automatico dopo il caricamento
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Salva i messaggi quando cambia qualcosa
  void _saveMessages() {
    MessageService.saveMessages(widget.chat.id, _messages);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      sender: 'Io',
      timestamp: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
    _saveMessages();
    
    // Scroll automatico verso il basso
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simula una risposta automatica
    Future.delayed(const Duration(seconds: 2), () {
      final replyMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _getAutoReply(widget.chat.id),
        sender: widget.chat.name,
        timestamp: DateTime.now(),
        isMe: false,
      );
      
      setState(() {
        _messages.add(replyMessage);
      });
      
      _saveMessages();
      
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Risposta automatica diversa per ogni chat
  String _getAutoReply(String chatId) {
    switch (chatId) {
      case '1':
        return 'Perfetto. A stasera allora';
      case '2':
        return 'Ricevuto Ti aggiorno';
      case '3':
        return 'Organizziamo tutto ';
      default:
        return 'Messaggio ricevuto';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF25D366),
              child: Text(
                widget.chat.avatar,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'online',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: (
             ) {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://user-images.githubusercontent.com/15075759/28719144-86dc0f70-73b1-11e7-911d-60d70fcded21.png',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'Nessun messaggio ancora.\nInizia a chattare! 💬',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isMe ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isMe)
              Text(
                message.sender,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal[700],
                ),
              ),
            const SizedBox(height: 2),
            Text(
              message.text,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 16,
                    color: Colors.blue[400],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Messaggio',
                  border: InputBorder.none,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {},
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}