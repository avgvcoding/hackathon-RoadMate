import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AnimatedDots extends StatefulWidget {
  // ignore: use_super_parameters
  const AnimatedDots({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedDotsState createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> {
  late Timer _timer;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      setState(() {
        _dotCount = _dotCount % 3 + 1;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      List.filled(_dotCount, '.').join(),
      style: const TextStyle(color: Colors.white, fontSize: 24),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String geminiApiKey = '';

  static const String _typingIndicator = '__typing_indicator__';

  @override
  void initState() {
    super.initState();
    _addMessage(
        "Hi this is RoadMate chatbot and I can help you if you get stuck in your vehicle or you need assistance in case of your vehicle breakdown by providing you tutorials on how to fix your vehicle. How may I help you today?",
        false);
  }

  void _addMessage(String message, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: isUser));
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    _addMessage(text, true);
    _sendMessageToGemini();
  }

  List<Map<String, dynamic>> _buildConversationContext() {
    return _messages.map((msg) {
      return {
        'role': msg.isUser ? 'user' : 'model',
        'parts': [
          {'text': msg.text}
        ]
      };
    }).toList();
  }

  Future<void> _sendMessageToGemini() async {
    final Uri url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey');

    final Map<String, dynamic> requestBody = {
      'contents': _buildConversationContext(),
      "generationConfig": {
        "temperature": 1.0,
        "maxOutputTokens": 2000,
        "topP": 0.95,
        "topK": 40,
      },
    };

    _addMessage(_typingIndicator, false);

    try {
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      setState(() {
        _messages
            .removeWhere((msg) => msg.text == _typingIndicator && !msg.isUser);
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('candidates') &&
            data['candidates'] is List &&
            data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          final candidateContent = candidate['content'];
          if (candidateContent != null &&
              candidateContent['parts'] != null &&
              candidateContent['parts'] is List &&
              candidateContent['parts'].isNotEmpty) {
            final botResponse = candidateContent['parts'][0]['text'] as String;
            _addMessage(botResponse, false);
          } else {
            _addMessage("Error: Unexpected response structure", false);
          }
        } else {
          _addMessage("Error: No response candidates", false);
        }
      } else {
        _addMessage(
            "Error: ${response.statusCode} ${response.reasonPhrase}", false);
      }
    } catch (e) {
      setState(() {
        _messages
            .removeWhere((msg) => msg.text == _typingIndicator && !msg.isUser);
      });
      _addMessage("Error: $e", false);
    }
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type your message",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black45,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final alignment =
        message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isUser ? Colors.blueAccent : Colors.grey[800]!;
    final borderRadius = message.isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
        ),
        child: message.isUser
            ? Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              )
            : (message.text == _typingIndicator
                ? const AnimatedDots()
                : MarkdownBody(
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: Colors.white),
                      code: const TextStyle(
                        color: Colors.white70,
                        backgroundColor: Colors.black45,
                      ),
                      blockquote: const TextStyle(color: Colors.white70),
                      a: const TextStyle(color: Colors.blueAccent),
                    ),
                  )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RoadMate Chatbot",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(222, 7, 7, 7),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/chatbot_bg.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                const Color.fromARGB(137, 4, 4, 4), BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(_messages[index]);
                  },
                ),
              ),
              const Divider(height: 1.0, color: Colors.white54),
              _buildTextComposer(),
            ],
          ),
        ),
      ),
    );
  }
}
