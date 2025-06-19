import 'package:flutter/material.dart';
import 'package:berita12/views/splash_screen_page.dart';
import 'package:berita12/views/login_page.dart';
import 'package:berita12/views/register_page.dart';
// import 'package:berita12/views/forgot_password_page.dart';
import 'package:berita12/views/home_page.dart'; // Jika sudah ada halaman utama
import 'package:berita12/views/bookmark_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita12',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/bookmark', // Ganti dengan rute awal yang diinginkan
      routes: {
        // '/': (context) => const SplashScreenPage(),
        // '/login': (context) => const LoginPage(),
        // '/register': (context) => const RegisterPage(), 
        '/home': (context) => const HomePage(), 
        '/bookmark': (context) => const BookmarkPage(), 
      },
    );
  }
}
