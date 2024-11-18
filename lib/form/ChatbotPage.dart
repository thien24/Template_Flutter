import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatbotPage(),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  bool _isDarkMode = false;
  bool _isTyping = false; // Thêm biến để lưu trạng thái soạn tin của chatbot
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": userMessage});
      _isTyping = true; // Bắt đầu trạng thái "đang soạn tin" khi gửi tin nhắn
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('https://server-chatbot-h5el.onrender.com/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chatbotReply = data['reply'];

        setState(() {
          _messages.add({"sender": "chatbot", "message": chatbotReply});
        });
      } else {
        setState(() {
          _messages.add(
              {"sender": "chatbot", "message": "Lỗi khi kết nối đến server!"});
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        _messages.add(
            {"sender": "chatbot", "message": "Không thể kết nối với server!"});
      });
    } finally {
      setState(() {
        _isTyping =
            false; // Tắt trạng thái "đang soạn tin" sau khi nhận phản hồi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 30,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "Chatbot",
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length +
                  (_isTyping ? 1 : 0), // Thêm 1 nếu chatbot đang soạn tin
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chatbot đang soạn tin...",
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }

                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: Align(
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isUserMessage
                            ? (_isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[800])
                            : (_isDarkMode ? Colors.black : Colors.grey[300]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                          color: isUserMessage
                              ? Colors.white
                              : (_isDarkMode ? Colors.white70 : Colors.black),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic,
                      color: _isDarkMode ? Colors.white : Colors.black),
                  onPressed: () {
                    // Hành động cho mic
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image,
                      color: _isDarkMode ? Colors.white : Colors.black),
                  onPressed: () {
                    print('Gửi hình ảnh');
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      hintStyle: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: _isDarkMode ? Colors.black : Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,
                      color: _isDarkMode ? Colors.white : Colors.black),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
