import 'package:flutter/material.dart';
import 'package:flutter_application_8/main.dart'; // Nhập khẩu main.dart
import 'travel.dart'; // Nhập khẩu travel.dart
import 'sign_up.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00CEA6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromARGB(255, 246, 245, 245),
                                width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/danang.png',
                              width: 32.22,
                              height: 38,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 130, 0, 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.elliptical(250, 50)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                          child: Text(
                            'Welcome back, Yoo Jin',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Vui lòng nhập email';
                                    }
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]")
                                        .hasMatch(value)) {
                                      return 'Email không hợp lệ';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _emailController.text = value!;
                                  },
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Password',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  validator: (value) {
                                    RegExp regex = RegExp(r'^.{6,}$');
                                    if (value!.isEmpty) {
                                      return 'Vui lòng nhập mật khẩu';
                                    }
                                    if (!regex.hasMatch(value)) {
                                      return 'Mật khau không hợp lệ';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _passwordController.text = value!;
                                  },
                                  obscureText: true,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    // Chuyển đến TravelPage mà không cần kiểm tra thông tin
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TravelPage(),
                                      ),
                                    );
                                    print('Đăng nhập thành công');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 0, 206, 166)),
                                  child: SizedBox(
                                    width: 300,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Or sign in with')],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/face.png',
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 20),
                                    Image.asset(
                                      'assets/talk.png',
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 20),
                                    Image.asset(
                                      'assets/line.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account? "),
                                    GestureDetector(
                                      onTap: () {
                                        // Điều hướng đến SignUp
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUp(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 206, 166),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
