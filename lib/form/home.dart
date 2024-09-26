import 'package:flutter/material.dart';
import 'travel.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TravelPage()),
              );
            },
          ),
          flexibleSpace: Stack(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://tiki.vn/blog/wp-content/uploads/2023/03/cau-rong-da-nang.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plenty of amazing tours',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'are waiting for you',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // Search bar below AppBar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Hi, where do you want to explore?',
                  hintStyle: TextStyle(
                    height: 1.5,
                    color: Color.fromARGB(180, 153, 236, 218),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          // TabBar with two tabs
         
          // TabBarView for content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AvailableTours(),
                WishList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF00C39A),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Updated AvailableTours class
class AvailableTours extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        TourCard(
          imageUrl: 'assets/halong.png',
          location: "Melbourne - Sydney",
          date: "Jan 30, 2020",
          duration: "3 days",
          price: "\$600.00",
          likes: 1247,
          rating: 5,
        ),
        TourCard(
          imageUrl: 'assets/uc.png',
          location: 'Hanoi - Ha Long Bay',
          date: 'Jan 30, 2020',
          duration: '3 days',
          price: '\$300.00',
          likes: 1342,
          rating: 5,
        ),
        TourCard(
          imageUrl: 'assets/hcm.png',
          location: 'HCM City - Mekong Delta',
          date: 'Feb 20, 2020',
          duration: '2 days',
          price: '\$250.00',
          likes: 800,
          rating: 4,
        ),
        TourCard(
          imageUrl: 'assets/hanoi.png',
          location: 'Hanoi - Sapa',
          date: 'Mar 15, 2020',
          duration: '4 days',
          price: '\$450.00',
          likes: 1100,
          rating: 5,
        ),
      ],
    );
  }
}

class TourCard extends StatelessWidget {
  final String location;
  final String date;
  final String price;
  final String imageUrl;
  final String duration;
  final int likes;
  final int rating;

  TourCard({
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.duration,
    required this.price,
    required this.likes,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.asset(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow[700],
                          size: 16.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$likes likes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 24.0,
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.date_range, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                        SizedBox(width: 4.0),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WishList class
class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              ],
            ),
          ),
        );
      },
    );
  }
}
