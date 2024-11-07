import 'package:flutter/material.dart';
import 'package:flutter_application_8/form/Home.dart';
import 'package:flutter_application_8/form/sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'chat.dart';
import 'search.dart'; // Nhập SearchPage ở đây
import 'Home.dart';
import 'Profile.dart';

class City {
  final String name;
  final String imageUrl;
  final String tripName;
  final String date;
  final String time;
  final String guide;
  final Map<String, String> actions;

  City({
    required this.name,
    required this.imageUrl,
    required this.tripName,
    required this.date,
    required this.time,
    required this.guide,
    required this.actions,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? 'Unknown City',
      imageUrl: json['imageURL'] ?? '',
      tripName: json['trip']['tripName'] ?? 'Unknown Trip',
      date: json['trip']['date'] ?? 'Unknown Date',
      time: json['trip']['time'] ?? 'Unknown Time',
      guide: json['trip']['guide'] ?? 'Unknown Guide',
      actions: Map<String, String>.from(json['trip']['actions']),
    );
  }
}

Future<List<City>> fetchCities() async {
  final response =
      await http.get(Uri.parse('https://api-flutter-ivay.onrender.com/trip'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => City.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load cities');
  }
}

class TravelPage extends StatelessWidget {
  const TravelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://tiki.vn/blog/wp-content/uploads/2023/03/cau-rong-da-nang.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTripContainer('Current Trip'),
                          _buildTripContainer('Next Trip'),
                          _buildTripContainer('Past Trip'),
                          _buildTripContainer('Wish List', isWishList: true),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<List<City>>(
                        future: fetchCities(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Lỗi: ${snapshot.error}'));
                          } else {
                            final cities = snapshot.data!;
                            return Flexible(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: cities.length,
                                itemBuilder: (context, index) {
                                  return _buildCityCard(cities[index]);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 215, 218, 212),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.lightGreen, width: 2),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.lightGreen,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.textsms), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeApp()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatApp()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchPage()), // Chuyển đến màn hình SearchPage
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://tiki.vn/blog/wp-content/uploads/2023/03/cau-rong-da-nang.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: AppBar(
        title: const Text('Create New Trip'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildTripContainer(String title, {bool isWishList = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isWishList ? Colors.green : Colors.white,
        border: Border.all(
            color: const Color.fromARGB(255, 243, 244, 243), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title),
    );
  }

  Widget _buildCityCard(City city) {
    return Card(
      margin: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              city.imageUrl.isNotEmpty
                  ? Image.network(
                      city.imageUrl,
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image, size: 80, color: Colors.grey),
              Positioned(
                left: 4,
                top: 60,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 140,
                      child: Text(
                        city.name,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 245, 244, 244),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  city.tripName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      city.date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      city.time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      city.guide,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: city.actions.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 12, color: Colors.green),
                          const SizedBox(width: 2),
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
