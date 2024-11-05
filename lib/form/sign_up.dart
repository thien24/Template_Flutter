import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import dart:convert for jsonEncode

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedRole = "Traveler";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  _buildBackgroundContainer(),
                  _buildSignUpForm(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundContainer() {
    return Container(
      color: const Color.fromARGB(250, 0, 206, 166),
      width: double.infinity,
      height: 950,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFF6F5F5),
                width: 2,
              ),
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
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Positioned(
      top: 130,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.elliptical(250, 50)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildRoleSelection(),
                // Sử dụng Row để hiển thị First Name và Last Name trên cùng một hàng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildTextField('First Name', _firstNameController,
                          'Please enter your first name'),
                    ),
                    const SizedBox(width: 20), // Khoảng cách giữa hai trường
                    Expanded(
                      child: _buildTextField('Last Name', _lastNameController,
                          'Please enter your last name'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField(
                    'Country', _countryController, 'Please enter your country'),
                const SizedBox(height: 20),
                _buildTextField('Email', _emailController,
                    'Please enter a valid email address',
                    isEmail: true),
                const SizedBox(height: 20),
                _buildTextField('Password', _passwordController,
                    'Password must be at least 6 characters long',
                    isPassword: true),
                const SizedBox(height: 20),
                _buildTextField('Confirm Password', _confirmPasswordController,
                    'Passwords do not match',
                    isPassword: true, confirmPassword: true),
                const SizedBox(height: 20),
                _buildTermsAndConditions(),
                const SizedBox(height: 20),
                _buildSignUpButton(context),
                const SizedBox(height: 20),
                _buildSignInLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            title: const Text("Traveler"),
            value: "Traveler",
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text("Guide"),
            value: "Guide",
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String errorMessage,
      {bool isEmail = false,
      bool isPassword = false,
      bool confirmPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: label),
          obscureText: isPassword,
          validator: (value) {
            if (value!.isEmpty) {
              return errorMessage;
            }
            if (isEmail &&
                !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]")
                    .hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            if (confirmPassword && value != _passwordController.text) {
              return 'Passwords do not match';
            }
            if (isPassword && value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return const Text.rich(
      TextSpan(
        text: 'By Signing Up, you agree to our ',
        children: [
          TextSpan(
            text: 'Terms & Conditions',
            style: TextStyle(
                color: Color(0xFF00CEA6), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final response = await http.post(
            Uri.parse('https://api-flutter-8wm7.onrender.com/user/signup'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'firstName': _firstNameController.text,
              'lastName': _lastNameController.text,
              'country': _countryController.text,
              'email': _emailController.text,
              'password': _passwordController.text,
              'role': _selectedRole,
            }),
          );

          if (response.statusCode == 201) {
            print('Sign Up Successful');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign Up Successful')),
            );
          } else {
            print('Failed to Sign Up: ${response.body}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to Sign Up: ${response.body}')),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00CEA6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            'SIGN UP',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Back to Sign In screen
          },
          child: const Text(
            'Sign In',
            style: TextStyle(
                color: Color(0xFF00CEA6), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
