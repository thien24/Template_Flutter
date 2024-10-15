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
  final response = await http.get(Uri.parse('http://localhost:3000/trip'));

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
            decoration: BoxDecoration(
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTripContainer('Current Trip'),
                          _buildTripContainer('Next Trip'),
                          _buildTripContainer('Past Trip'),
                          _buildTripContainer('Wish List', isWishList: true),
                        ],
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<List<City>>(
                        future: fetchCities(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Lỗi: ${snapshot.error}'));
                          } else {
                            final cities = snapshot.data!;
                            return Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
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
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 215, 218, 212),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.lightGreen, width: 2),
              ),
              child: Icon(
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
        items: [
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
            // Điều hướng đến trang SearchPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchPage()), // Chuyển đến màn hình SearchPage
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://tiki.vn/blog/wp-content/uploads/2023/03/cau-rong-da-nang.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: AppBar(
        title: Text('Create New Trip'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildTripContainer(String title, {bool isWishList = false}) {
    return Container(
      padding: EdgeInsets.all(8),
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
      margin: EdgeInsets.all(4),
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
                  : Icon(Icons.image, size: 80, color: Colors.grey),
              Positioned(
                left: 4,
                top: 60,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Container(
                      width: 140,
                      child: Text(
                        city.name,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 245, 244, 244),
                          fontSize: 12,
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
                SizedBox(height: 2),
                Text(
                  city.tripName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      city.date,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 10, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      city.time,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.person, size: 10, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      city.guide,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: city.actions.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              size: 10, color: Colors.green),
                          SizedBox(width: 2),
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 10,
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
