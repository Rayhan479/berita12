import 'package:berita12/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // Pastikan ini ada
// import 'dart:convert'; // Pastikan ini ada
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Pastikan ini ada
import 'package:berita12/model/article_model.dart'; // Import Article model // Import ApiService
import 'package:berita12/views/news_detail_page.dart'; // Untuk navigasi ke detail
// import 'package:berita12/views/home_page.dart'; // Untuk navigasi bottom bar
// import 'package:berita12/views/add_news_page.dart'; // Untuk navigasi bottom bar
// import 'package:berita12/views/my_news_page.dart'; // Untuk navigasi bottom bar
// import 'package:berita12/views/profile_page.dart'; // Untuk navigasi bottom bar


// Pastikan ApiService dan Article model sudah diperbarui.

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    "Trending",
    "All",
    "Latest",
    "Teknologi",
    "Science",
    "Politik",
  ];

  List<Article> _bookmarkedArticles = []; // List untuk menyimpan artikel yang di-bookmark
  bool _isLoading = true;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchBookmarkedArticles(); // Ambil artikel yang di-bookmark saat halaman dimuat
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchBookmarkedArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final articles = await _apiService.getSavedArticles();
      setState(() {
        _bookmarkedArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat bookmark: ${e.toString()}';
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching bookmarked articles: $e');
      }
      // Anda mungkin ingin mengarahkan pengguna ke halaman login jika token tidak valid
      if (e.toString().contains('Pengguna belum login')) {
        // Example: Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  // Fungsi untuk menghapus bookmark dari halaman Bookmark
  Future<void> _removeBookmark(String articleId) async {
    setState(() {
      _isLoading = true; // Set loading state while deleting
    });
    try {
      await _apiService.removeBookmark(articleId);
      // Hapus dari daftar lokal dan refresh UI
      setState(() {
        _bookmarkedArticles.removeWhere((article) => article.id == articleId);
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark dihapus!')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menghapus bookmark: ${e.toString()}';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $_errorMessage')),
      );
      if (kDebugMode) {
        print('Error removing bookmark: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo_berita12.png',
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "My Bookmark",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x4D1E73BE),
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: const Icon(
                          Icons.filter_list_rounded,
                          color: Color(0xFF1E73BE),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search ...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
          _isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : _errorMessage != null
                  ? Expanded(child: Center(child: Text(_errorMessage!)))
                  : _bookmarkedArticles.isEmpty
                      ? const Expanded(child: Center(child: Text('Belum ada artikel yang di-bookmark.')))
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: _fetchBookmarkedArticles,
                            child: ListView.builder(
                              itemCount: _bookmarkedArticles.length,
                              itemBuilder: (context, index) {
                                final article = _bookmarkedArticles[index];
                                return GestureDetector( // Tambahkan GestureDetector untuk navigasi ke detail
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsDetailPage(article: article),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              article.imageUrl,
                                              width: 100,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Image.network('https://placehold.co/100x80/A0A0A0/FFFFFF?text=No+Image', fit: BoxFit.cover),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  article.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.thumb_up_alt_outlined,
                                                      size: 16,
                                                      color: Colors.blue,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text('20'),
                                                    const SizedBox(width: 12),
                                                    const Icon(
                                                      Icons.chat_bubble_outline,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text('120'),
                                                    const Spacer(),
                                                    // Tombol Bookmark yang bisa di-toggle (untuk hapus bookmark)
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.bookmark, // Selalu terisi di halaman bookmark
                                                        color: Colors.blue,
                                                      ),
                                                      onPressed: () => _removeBookmark(article.id), // Fungsi untuk menghapus
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
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
          padding: const EdgeInsets.symmetric(
            horizontal: 2.0,
            vertical: 8.0,
          ),
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
                    // Current page is Bookmark, no navigation needed
                  },
                  icon: const Icon(Icons.bookmark, color: Colors.white), // Ikon bookmark terisi di sini
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/mynews');
                  },
                  icon: const Icon(
                    Icons.how_to_vote_outlined,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  icon: const Icon(Icons.person_outline, color: Colors.white),
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
