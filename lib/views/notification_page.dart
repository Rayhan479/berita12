import 'package:flutter/material.dart';
import 'home_page.dart'; // Ganti ini dengan path ke halaman Home kamu

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E73BE)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF1E73BE),
              radius: 80,
              child: Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 80,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'you Have No Notifications',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1E73BE),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
