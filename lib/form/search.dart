import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'travel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> _searchResults = [];
  String _query = '';

  Future<void> _search(String query) async {
    final response = await http
        .get(Uri.parse('https://api-flutter-8wm7.onrender.com/address'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Lọc dữ liệu dựa trên từ khóa tìm kiếm
      setState(() {
        _searchResults = data
            .where((item) =>
                item['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mời ae search'),
        backgroundColor:
            const Color.fromRGBO(202, 241, 234, 1), // Đặt màu nền cho AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TravelPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm điểm đến, tour...',
                filled: true,
                fillColor: Color.fromARGB(180, 214, 237, 231),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
                // Gọi hàm tìm kiếm
                if (value.isNotEmpty) {
                  _search(value);
                } else {
                  setState(() {
                    _searchResults.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(result['avatar'] ?? ''),
                    ),
                    title: Text(result['name']),
                    subtitle: Text(
                        'Thành phố: ${result['city'] ?? 'Không có thông tin'}'),
                    onTap: () {
                      // Điều hướng đến trang chi tiết với thông tin đã chọn
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            name: result['name'],
                            avatar: result['avatar'],
                            city: result['city'],
                            imageCity: result['imagecity'],
                            note: result['note'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String name;
  final String avatar;
  final String city;
  final String imageCity;
  final String note;

  const DetailPage(
      {super.key,
      required this.name,
      required this.avatar,
      required this.city,
      required this.imageCity,
      required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        backgroundColor: const Color.fromARGB(255, 216, 231, 229),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(avatar),
              radius: 40,
            ),
            const SizedBox(height: 10),
            Text('Tên: $name',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Thành phố: $city', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Image.network(imageCity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text('Ghi chú: $note', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
