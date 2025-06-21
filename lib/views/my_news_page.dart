import 'package:berita12/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../model/article_model.dart';
import '../services/api_service.dart';
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:berita12/model/article_model.dart';
// Pastikan ini diimpor dengan benar
import 'package:berita12/views/bookmark_page.dart';
import 'package:berita12/views/add_news_page.dart';
import 'package:berita12/views/profile_page.dart';
import 'package:berita12/views/home_page.dart';
import 'package:berita12/views/edit_news_page.dart'; // Import EditNewsPage yang baru
>>>>>>> 84cfed050d0b1a0fa5ed366cfaef85d44f8f06b9

class MyNewsPage extends StatefulWidget {
  const MyNewsPage({super.key});

  @override
  State<MyNewsPage> createState() => _MyNewsPageState();
}

<<<<<<< HEAD
class _MyNewsPageState extends State<MyNewsPage> {
  late Future<List<Article>> _myArticles;
=======
class _MyNewsPageState extends State<MyNewsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Trending', 'All', 'Latest', 'Teknologi', 'Science', 'Politik'];

  List<Article> _myArticles = []; // List untuk menyimpan artikel pengguna
  bool _isLoading = true; // Status loading data
  String? _errorMessage; // Pesan error jika terjadi
  final ApiService _apiService = ApiService(); // Instansiasi ApiService
>>>>>>> 84cfed050d0b1a0fa5ed366cfaef85d44f8f06b9

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _myArticles = ApiService().fetchUserArticles(); // Pastikan ada method ini di api_service.dart
=======
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchMyArticles(); // Panggil fungsi untuk mengambil artikel saat halaman dimuat
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil artikel pengguna dari API
  Future<void> _fetchMyArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Memanggil getMyArticles tanpa parameter token, karena ApiService akan menanganinya secara internal
      final articles = await _apiService.getMyArticles();
      setState(() {
        _myArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat artikel Anda: ${e.toString()}'; // Pesan error yang lebih spesifik
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching my articles: $e');
      }
      // Anda bisa menambahkan Navigator.pushNamed(context, '/login'); di sini
      // jika Anda ingin mengarahkan pengguna ke halaman login saat token tidak ditemukan.
    }
  }

  // Fungsi untuk menghapus artikel
  Future<void> _deleteArticle(String articleId) async {
    // Tampilkan dialog konfirmasi sebelum menghapus
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus artikel ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Batal
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Konfirmasi
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false; // Default to false if dialog is dismissed

    if (!confirmDelete) {
      return; // Jika tidak dikonfirmasi, jangan lakukan apa-apa
    }

    setState(() {
      _isLoading = true; // Tampilkan loading saat menghapus
    });

    try {
      await _apiService.deleteArticle(articleId);
      // Jika berhasil dihapus dari API, hapus dari list lokal
      setState(() {
        _myArticles.removeWhere((article) => article.id == articleId);
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel berhasil dihapus!')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menghapus artikel: ${e.toString()}';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $_errorMessage')),
      );
      if (kDebugMode) {
        print('Error deleting article: $e');
      }
    }
>>>>>>> 84cfed050d0b1a0fa5ed366cfaef85d44f8f06b9
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => Navigator.pushNamed(context, '/add'),
        backgroundColor: const Color(0xFF1E73BE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
=======
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo_berita12.png', height: 70), // Ganti dengan logo Anda
            const SizedBox(width: 8),
            const Text(
              'My News',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}), // Contoh icon menu
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),

            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                height: 35,
                child: TabBar( // Menggunakan TabBar dengan controller
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.transparent, // Sembunyikan indikator bawaan
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
            ),

            // Daftar Berita (Artikel Pengguna)
            _isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : _errorMessage != null
                    ? Expanded(child: Center(child: Text(_errorMessage!)))
                    : _myArticles.isEmpty
                        ? const Expanded(child: Center(child: Text('Anda belum membuat berita.')))
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: _fetchMyArticles, // Izinkan pull-to-refresh
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _myArticles.length,
                                itemBuilder: (context, index) {
                                  final article = _myArticles[index];
                                  return NewsCard(
                                    article: article,
                                    onDelete: () => _deleteArticle(article.id), // article.id! karena kita yakin id ada dari API
                                    onEdit: () async {
                                      // Navigasi ke EditNewsPage dan tunggu hasilnya
                                      final bool? result = await Navigator.pushNamed(
                                        context,
                                        '/edit', // Nama rute yang telah ditentukan di main.dart
                                        arguments: article, // Teruskan objek article
                                      ) as bool?; // Cast hasil kembali ke bool?

                                      // Jika update berhasil (result adalah true), refresh daftar artikel
                                      if (result == true) {
                                        _fetchMyArticles();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
          ],
        ),
      ),
      // ======= BottomAppBar + FAB =======
>>>>>>> 84cfed050d0b1a0fa5ed366cfaef85d44f8f06b9
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF1E73BE),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  icon: const Icon(Icons.home_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/bookmark'),
                  icon: const Icon(Icons.bookmark_outline, color: Colors.white),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/mynews'),
                  icon: const Icon(Icons.how_to_vote, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                  icon: const Icon(Icons.person_outline, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
<<<<<<< HEAD
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Image.asset('assets/images/logo_berita12.png', height: 70),
                  const SizedBox(width: 8),
                  const Text('My News', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                ],
              ),
            ),

            // Content
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: _myArticles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada berita yang kamu buat."));
                  }

                  final articles = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return NewsCard(article: article);
                    },
                  );
                },
              ),
            ),
          ],
        ),
=======
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

// Mengubah NewsCard menjadi StatelessWidget yang menerima Article
class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const NewsCard({
    super.key,
    required this.article,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              article.imageUrl, // Gunakan gambar dari artikel
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.network('https://placehold.co/100x100/A0A0A0/FFFFFF?text=No+Image', fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title, // Gunakan judul dari artikel
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Text('120}'), // Gunakan likes dari artikel
                      const SizedBox(width: 12),
                      const Icon(Icons.comment, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Text('20'), // Gunakan comments dari artikel
                      const Spacer(),
                      // Tombol Edit
                      IconButton(
                        icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                        onPressed: onEdit, // Panggil onEdit yang disediakan dari parent
                      ),
                      // Tombol Delete
                      IconButton(
                        icon: const Icon(Icons.delete, size: 16, color: Colors.red), // Icon delete
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
>>>>>>> 84cfed050d0b1a0fa5ed366cfaef85d44f8f06b9
      ),
    );
  }
}

<<<<<<< HEAD
class NewsCard extends StatelessWidget {
  final Article article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              article.imageUrl ?? '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, _) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.thumb_up, color: Colors.blue, size: 16),
                      SizedBox(width: 4),
                      Text('316K'),
                      SizedBox(width: 12),
                      Icon(Icons.comment, color: Colors.blue, size: 16),
                      SizedBox(width: 4),
                      Text('110K'),
                      Spacer(),
                      Icon(Icons.edit, size: 16, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
=======
// Mengubah TabItem agar lebih dinamis jika diperlukan
class TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  const TabItem({super.key, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.black : Colors.grey,
        ),
>>>>>>> 84cfed050d0b1a0fa5ed366cfaef85d44f8f06b9
      ),
    );
  }
}
