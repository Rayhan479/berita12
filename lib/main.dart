import 'package:berita12/model/article_model.dart';
import 'package:berita12/views/news_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:berita12/views/splash_screen_page.dart';
import 'package:berita12/views/login_page.dart';
import 'package:berita12/views/register_page.dart';
import 'package:berita12/views/profile_page.dart';
import 'package:berita12/views/home_page.dart';
import 'package:berita12/views/bookmark_page.dart';
import 'package:berita12/views/add_news_page.dart';
import 'package:berita12/views/my_news_page.dart';
import 'package:berita12/views/notification_page.dart';
import 'package:berita12/views/edit_news_page.dart'; // Import EditNewsPage yang baru


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
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/bookmark': (context) => const BookmarkPage(),
        '/add': (context) => const CreateNewsPage(),
        '/profile': (context) => const ProfilePage(),
        '/mynews': (context) => const MyNewsPage(),
        // '/news': (context) => const NewsDetailPage(), // Tidak perlu ini jika menggunakan onGenerateRoute
        '/notification': (context) => const NotificationPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          // Rute untuk menampilkan detail berita
          final Article article = settings.arguments as Article;
          return MaterialPageRoute(
            builder: (context) => NewsDetailPage(article: article),
          );
        } else if (settings.name == '/edit') {
          // Rute baru untuk mengedit berita
          final Article article = settings.arguments as Article;
          return MaterialPageRoute(
            builder: (context) => EditNewsPage(article: article),
          );
        }
        // Jika rute tidak ditemukan di `routes` dan bukan rute dinamis, kembalikan null
        return null;
      },
    );
  }
}
