import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'travel.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> _searchResults = [];
  String _query = '';

  Future<void> _search(String query) async {
    final response = await http.get(Uri.parse('http://localhost:3000/address'));

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
        title: Text('Mời ae search'),
        backgroundColor:
            const Color.fromRGBO(202, 241, 234, 1), // Đặt màu nền cho AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TravelPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm điểm đến, tour...',
                filled: true,
                fillColor: const Color.fromARGB(180, 214, 237, 231),
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
            SizedBox(height: 20),
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

  DetailPage(
      {required this.name,
      required this.avatar,
      required this.city,
      required this.imageCity,
      required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết'),
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
            SizedBox(height: 10),
            Text('Tên: $name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Thành phố: $city', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Image.network(imageCity, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text('Ghi chú: $note', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
