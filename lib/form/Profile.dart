import 'package:flutter/material.dart';
import 'package:flutter_application_8/form/travel.dart';
import 'travel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Background Header Image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset('assets/buon.png').image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Back arrow positioned at the top-left corner
                Positioned(
                  top: 20,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TravelPage()),
                      ); // Go back to the previous page)// Back to the previous page
                    },
                  ),
                ),
                // Settings icon
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.settings,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Adjusted Stack for avatar and My Photos section
            Stack(
              clipBehavior: Clip.none, // Allow avatar to overlap
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height:
                              80), // Increased space to avoid overlapping text
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Photos',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Use Wrap widget to wrap photos to next line
                      Wrap(
                        spacing: 8.0, // Horizontal space between photos
                        runSpacing: 8.0, // Vertical space between rows
                        children: [
                          _buildPhotoItem('assets/zalo3.png'),
                          _buildPhotoItem('assets/zalo2.png'),
                          _buildPhotoItem('assets/zalo1.png'),
                          _buildPhotoItem('assets/zalo4.png'),
                          _buildPhotoItem('assets/zalo5.png'),
                          _buildPhotoItem('assets/zalo6.png'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Avatar and text side by side
                Positioned(
                  top: -40, // Adjust this to control avatar position
                  left: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 47,
                          backgroundImage: AssetImage('assets/anhthien.png'),
                        ),
                      ),
                      const SizedBox(
                          width: 20), // Space between avatar and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          const Text(
                            'Van Thien',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'thien98405@donga.edu.vn',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build a photo item in the My Photos section
  Widget _buildPhotoItem(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imageUrl,
        height: 150, // Set height to 150
        width: 150, // Set width to 150
        fit: BoxFit.cover,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 163, 167),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Info at the top
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/anhthien.png'),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Van Thien',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Buon ngu'),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()),
                    ); // Navigate to Edit Profile Page
                  },
                  child: const Text('EDIT PROFILE'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Settings options
            SwitchListTile(
              title: const Text('Notifications'),
              value: true,
              onChanged: (bool value) {
                // Handle notification toggle
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Languages'),
              onTap: () {
                // Handle languages click
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment'),
              onTap: () {
                // Handle payment click
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy & Policies'),
              onTap: () {
                // Handle privacy and policies click
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                // Handle feedback click
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Usage'),
              onTap: () {
                // Handle usage click
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle sign out
                },
                child:
                    const Text('Sign out', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 163, 167),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color.fromARGB(255, 156, 163, 167),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Thực hiện logic lưu profile ở đây
            },
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar và nút chỉnh sửa
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/anhthien.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.teal),
                      onPressed: () {
                        // Thêm logic chọn ảnh
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // First Name
            const TextField(
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: 'Van',
              ),
            ),
            const SizedBox(height: 10),
            // Last Name
            const TextField(
              decoration: InputDecoration(
                labelText: 'Last Name',
                hintText: 'Thien',
              ),
            ),
            const SizedBox(height: 10),
            // Password
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 10),
            // Change Password link
            TextButton(
              onPressed: () {
                // Logic đổi mật khẩu
              },
              child: const Text(
                'Change Password',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
