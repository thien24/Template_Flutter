import 'package:flutter/material.dart';
import 'package:flutter_application_8/form/sign_in.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 9), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sử dụng AspectRatio để giữ tỉ lệ chính xác
            Expanded(
              child: AspectRatio(
                aspectRatio:
                    1, // Tỉ lệ của animation, bạn có thể điều chỉnh nếu cần
                child: Lottie.asset(
                  'assets/animation/loading.json', // Thêm file Lottie của bạn vào đây
                  fit: BoxFit.contain, // Giữ tỉ lệ cho animation
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Loading...",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white), // Màu chữ trắng để dễ đọc trên nền đen
            ),
          ],
        ),
      ),
    );
  }
}
