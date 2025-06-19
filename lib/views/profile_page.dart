import 'dart:io';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Berita12';
  String email = 'berita12@gmail.com';
  String password = '********';
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_berita12.png',
              width: 70,
            ),
            const SizedBox(width: 8),
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: imageFile != null
                  ? FileImage(imageFile!)
                  : const AssetImage('assets/images/profile_placeholder.png')
                      as ImageProvider,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/editprofile');
              if (result != null && result is Map) {
                setState(() {
                  name = result['name'] ?? name;
                  email = result['email'] ?? email;
                  password = result['password'] ?? password;
                  imageFile = result['image'] ?? imageFile;
                });
              }
            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Color(0xFF1E73BE),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 214, 211, 211),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: name,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 214, 211, 211),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: email,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  obscureText: true,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 214, 211, 211),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: password,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E73BE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF1E73BE),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
          child: SizedBox(
            height: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  icon: const Icon(Icons.home_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/bookmark');
                  },
                  icon: const Icon(Icons.bookmark_outline, color: Colors.white),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/mynews');
                  },
                  icon: const Icon(Icons.how_to_vote_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: const Color(0xFF1E73BE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
