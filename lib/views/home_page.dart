import 'dart:convert';
import 'package:berita12/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Pastikan ini ada
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Pastikan ini ada
import 'package:carousel_slider/carousel_slider.dart';
import 'package:berita12/model/article_model.dart';
import 'package:berita12/views/news_detail_page.dart';
import 'package:berita12/views/notification_page.dart';
import 'package:berita12/views/bookmark_page.dart';
import 'package:berita12/views/add_news_page.dart';
import 'package:berita12/views/my_news_page.dart';
import 'package:berita12/views/profile_page.dart';
 // Import ApiService

// DUMMY_JWT_TOKEN_FOR_TESTING TELAH DIHAPUS DARI FILE INI.
// Pastikan proses login Anda menyimpan token asli ke secure storage.


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  List<Article> _userArticles = [];
  bool _isLoading = true;
  String? _error;
  final ApiService _apiService = ApiService(); // Instansiasi ApiService

  final List<String> _tabs = [
    'Trending',
    'All',
    'Latest',
    'Teknologi',
    'Science',
    'Politik',
  ];
  final List<String> _carouselImages = [
    'https://image.idntimes.com/post/20191216/2-9d35e61e811b05aec40f694b1c1cc187.jpg?tr=w-1920,f-webp,q-75&width=1920&format=webp&quality=75',
    'https://cdn1.katadata.co.id/media/images/thumb/2025/04/24/BytePlus-2025_04_24-19_38_38_ac9eaf82bceb2d35497b001e844b0058_960x640_thumb.jpeg',
    'https://media.licdn.com/dms/image/D5612AQHVP143zP7nLg/article-cover_image-shrink_720_1280/0/1686807804814?e=2147483647&v=beta&t=S8NCUTpngKg2mYOSklk6rwyFLicGCHBnu1ZQ5gj3NbM',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchArticles(); // Langsung panggil _fetchArticles, tanpa inisialisasi dummy token
  }

  // Fungsi asinkron untuk mengambil artikel dari API dan status bookmarknya
  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Mengambil semua artikel dari API
      // Karena API tidak menyediakan endpoint untuk 'all news' secara langsung dengan status bookmark,
      // kita akan menggunakan 'getMyArticles' sebagai contoh untuk mendapatkan data artikel.
      // Anda mungkin perlu menyesuaikan ini jika ada endpoint 'getAllNews' di API Anda.
      final List<Article> fetchedArticles = await _apiService.getMyArticles(); // Mengambil artikel pengguna

      // Untuk setiap artikel, cek status bookmarknya
      List<Article> articlesWithBookmarkStatus = [];
      for (Article article in fetchedArticles) {
        // Karena id di model Article kita asumsikan tidak null setelah dari fromJson,
        // kita bisa langsung menggunakannya dengan operator !
        bool isBookmarked = await _apiService.checkBookmarkStatus(article.id);
        
        articlesWithBookmarkStatus.add(Article(
          id: article.id,
          title: article.title,
          category: article.category,
          readTime: article.readTime,
          imageUrl: article.imageUrl,
          isTrending: article.isTrending,
          tags: article.tags,
          content: article.content,
          isBookmarked: isBookmarked, // Menambahkan status bookmark yang sebenarnya
        ));
      }

      setState(() {
        _userArticles = articlesWithBookmarkStatus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat artikel: ${e.toString()}';
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching articles: $e');
      }
      // Jika error karena pengguna belum login (misalnya dari ApiService), arahkan ke login
      if (e.toString().contains('Pengguna belum login')) {
        // Contoh: Navigator.pushReplacementNamed(context, '/login');
        // Atau tampilkan pesan yang lebih ramah pengguna
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda belum login. Silakan login untuk melihat berita.')),
        );
      }
    }
  }

  // Fungsi untuk toggle bookmark
  Future<void> _toggleBookmark(Article article) async {
    // Karena id di model Article kita asumsikan tidak null, kita bisa langsung menggunakannya.
    // Tidak perlu lagi if (article.id == null)
    try {
      setState(() {
        // Perbarui status bookmark secara lokal terlebih dahulu untuk respons UI cepat
        int index = _userArticles.indexWhere((a) => a.id == article.id);
        if (index != -1) {
          _userArticles[index] = Article(
            id: article.id,
            title: article.title,
            category: article.category,
            readTime: article.readTime,
            imageUrl: article.imageUrl,
            isTrending: article.isTrending,
            tags: article.tags,
            content: article.content,
            isBookmarked: !(article.isBookmarked ?? false), // Toggle status, default false jika null
          );
        }
      });

      if (article.isBookmarked == true) { // Jika setelah di-toggle, statusnya true (artinya sebelumnya false)
        await _apiService.addBookmark(article.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel ditambahkan ke bookmark!')),
        );
      } else { // Jika setelah di-toggle, statusnya false (artinya sebelumnya true)
        await _apiService.removeBookmark(article.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark dihapus!')),
        );
      }
      // Opsional: _fetchArticles(); // Bisa uncomment ini jika ingin refresh penuh setelah setiap toggle
    } catch (e) {
      // Jika terjadi error, kembalikan status lokal ke semula
      setState(() {
        int index = _userArticles.indexWhere((a) => a.id == article.id);
        if (index != -1) {
          _userArticles[index] = Article(
            id: article.id,
            title: article.title,
            category: article.category,
            readTime: article.readTime,
            imageUrl: article.imageUrl,
            isTrending: article.isTrending,
            tags: article.tags,
            content: article.content,
            isBookmarked: !(article.isBookmarked ?? false), // Kembalikan status
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error bookmark: ${e.toString()}')),
      );
      if (kDebugMode) {
        print('Error toggling bookmark: $e');
      }
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo_berita12.png', height: 70),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0x4D1E73BE),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Color(0xFF1E73BE),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : RefreshIndicator(
                  onRefresh: _fetchArticles,
                  child: ListView.builder(
                    itemCount: _userArticles.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                        );
                      } else if (index == 1) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: CarouselSlider(
                            items: _carouselImages.asMap().entries.map((entry) {
                              String url = entry.value;
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.network('https://placehold.co/400x200/A0A0A0/FFFFFF?text=Image+Error', fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 30,
                                    left: 16,
                                    child: const Text(
                                      'Lorem Ipsum dolor sit colom',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4,
                                            color: Colors.black,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                          _carouselImages.asMap().entries.map((e) {
                                        return Container(
                                          width: 8.0,
                                          height: 8.0,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentIndex == e.key
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        final article = _userArticles[index - 2];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailPage(article: article),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      article.imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.network('https://placehold.co/100x100/A0A0A0/FFFFFF?text=Image+Not+Found', fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                                            Text('120'),
                                            const SizedBox(width: 12),
                                            const Icon(
                                              Icons.chat_bubble_outline,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text('20'),
                                            const Spacer(),
                                            // Ikon Bookmark yang bisa di-toggle
                                            IconButton(
                                              icon: Icon(
                                                article.isBookmarked == true ? Icons.bookmark : Icons.bookmark_border, // Ganti ikon berdasarkan status
                                                color: Colors.blue,
                                              ),
                                              onPressed: () => _toggleBookmark(article), // Panggil fungsi toggle
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
                      }
                    },
                  ),
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
                    // Current page is Home, no navigation needed if already on home
                  },
                  icon: const Icon(Icons.home, color: Colors.white),
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
