import 'package:flutter/material.dart';
import 'package:flutter_application_8/form/travel.dart';
import 'travel.dart';

// Màn hình chính
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Chat List'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatListScreen()),
            );
          },
        ),
      ),
    );
  }
}

// Màn hình hiển thị danh sách các cuộc trò chuyện
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ChatListScreen(), // gọi màn hình chat list
    );
  }
}

class ChatListScreen extends StatelessWidget {
  // Danh sách bạn bè với avatar
  final List<Map<String, dynamic>> _chatList = [
    {
      'name': 'Tuan Tran',
      'lastMessage': 'It\'s a beautiful place',
      'time': '10:30 AM',
      'avatar': 'assets/avatar1.png'
    },
    {
      'name': 'Emmy',
      'lastMessage': 'We can start at 8am',
      'time': '9:41 AM',
      'avatar': 'assets/avatar2.png'
    },
    {
      'name': 'Khai Ho',
      'lastMessage': 'See you tomorrow',
      'time': '11:30 AM',
      'avatar': 'assets/avatar3.png'
    },
    {
      'name': 'Q_My',
      'lastMessage': 'I\'m on my way',
      'time': 'Yesterday',
      'avatar': 'assets/avatar4.png'
    }
  ];

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0), // Chiều cao AppBar lớn hơn
        child: Container(
          height: 150.0, // Điều chỉnh chiều cao của AppBar
          decoration: const BoxDecoration(
            // Hình nền cho AppBar
            image: DecorationImage(
              image: NetworkImage(
                  'https://tiki.vn/blog/wp-content/uploads/2023/03/cau-rong-da-nang.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Thêm nút mũi tên quay lại
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TravelPage()),
                );
              },
            ),
            title: const Text('List Chat'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(
                0, 245, 244, 244), // Đặt nền của AppBar thành trong suốt
            elevation: 0, // Bỏ đổ bóng của AppBar
            flexibleSpace: Container(
              decoration: const BoxDecoration(),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _chatList.length,
        itemBuilder: (context, index) {
          final chat = _chatList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  AssetImage(chat['avatar']), // Hiển thị avatar cụ thể
            ),
            title: Text(chat['name']),
            subtitle: Text(chat['lastMessage']),
            trailing: Text(chat['time']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      friendName: chat['name'], friendAvatar: chat['avatar']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Màn hình chat với từng người bạn
class ChatScreen extends StatefulWidget {
  final String friendName;
  final String friendAvatar;

  const ChatScreen(
      {super.key, required this.friendName, required this.friendAvatar});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Tuan Tran',
      'message': 'hi, this is Emmy',
      'timestamp': '10:30 AM',
      'avatar': 'assets/avatar1.png'
    },
    {
      'sender': 'Emmy',
      'message':
          'It is a long established fact that a reader will be distracted by the...',
      'timestamp': '10:30 AM',
      'avatar': 'assets/avatar4.png'
    },
    {
      'sender': 'Khai Ho',
      'message': 'as opposed to using Content here',
      'timestamp': '10:31 AM',
      'avatar': 'assets/avatar3.png'
    },
    {
      'sender': 'Q_My',
      'message': 'There are many variations of passages',
      'timestamp': '10:32 AM',
      'avatar': 'assets/avatar4.png'
    },
    {
      'sender': 'Me',
      'message':
          'It is a long established fact that a reader will be distracted by the...',
      'timestamp': '10:30 AM',
      'avatar': ''
    },
  ];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': 'Me',
          'message': _controller.text,
          'timestamp': DateTime.now().toString().substring(11, 16), // HH:MM
          'avatar': ''
        });
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Thêm icon mũi tên quay lại
          onPressed: () {
            Navigator.pop(context); // Quay về màn hình trước
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage(widget.friendAvatar), // Avatar của người chat
            ),
            const SizedBox(width: 10),
            Text(widget.friendName), // Hiển thị tên bạn trên AppBar
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // Chức năng thêm bạn bè vào cuộc trò chuyện
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      '${widget.friendName} has been added as a friend!')));
            },
          )
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Center(child: Text("Jan 28, 2020")), // Hiển thị ngày
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'Me';
                return ListTile(
                  leading: isMe
                      ? null
                      : CircleAvatar(
                          backgroundImage: AssetImage(message[
                              'avatar']), // Hiển thị avatar của người gửi
                        ),
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe
                            ? const Color.fromARGB(255, 74, 195, 132)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['message'],
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            message['timestamp'],
                            style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.black45,
                                fontSize: 10),
                          ),
                        ],
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
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // Chức năng ghi âm
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    // Chức năng gửi hình ảnh
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.green,
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

void main() {
  runApp(ChatApp());
}
