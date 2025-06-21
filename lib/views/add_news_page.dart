// import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import 'package:berita12/model/article_model.dart';



class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  // Ubah _coverImage dari File? menjadi String? untuk menyimpan URL
  String? _coverImageUrl; // Mengubah tipe data untuk menyimpan URL
  String? selectedCategory;
  final List<String> categories = [
    "Teknologi",
    "Politik",
    "Science",
    "Olahraga",
  ];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController(); // Controller baru untuk input URL gambar
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool _isLoading = false;

  // Mengubah _pickImage menjadi _showImageUrlInputDialog
  Future<void> _showImageUrlInputDialog() async {
    String? newImageUrl = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Masukkan URL Gambar Cover'),
          content: TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(hintText: "URL Gambar"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, imageUrlController.text);
              },
            ),
          ],
        );
      },
    );

    if (newImageUrl != null && newImageUrl.isNotEmpty) {
      setState(() {
        _coverImageUrl = newImageUrl;
      });
    }
  }

  void _submitArticle() async {
    setState(() => _isLoading = true);

    final String title = titleController.text;
    final String? category = selectedCategory;
    final String content = contentController.text;
    final String tagsText = tagController.text;
    final String? imageUrl = _coverImageUrl; // Mengambil URL gambar dari state

    if (title.isEmpty || category == null || content.isEmpty || tagsText.isEmpty || imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan lengkapi semua data, termasuk URL gambar cover.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final article = Article(
      id: UniqueKey().toString(), // Untuk artikel baru, ID sementara atau null jika backend yang generate
      title: title,
      category: category,
      readTime: '20 Jun 2025', // Atau hitung berdasarkan panjang konten
      imageUrl: imageUrl, // Gunakan URL gambar yang diinput
      tags: tagsText.split(',').map((e) => e.trim()).toList(),
      content: content,
      // likes dan comments bisa null untuk artikel baru
    );

    final success = await ApiService().createNewsPage(article);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Artikel berhasil dipublikasikan!' : 'Gagal membuat artikel.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
    if (success) {
      // Bersihkan form setelah sukses
      titleController.clear();
      contentController.clear();
      tagController.clear();
      imageUrlController.clear();
      setState(() {
        selectedCategory = null;
        _coverImageUrl = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: const Text(
          "Create News",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              // Panggil fungsi baru untuk input URL
              onTap: _showImageUrlInputDialog,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [6, 3],
                color: Colors.grey,
                strokeWidth: 1.5,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    // Tampilkan gambar dari URL jika ada
                    image: _coverImageUrl != null && _coverImageUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(_coverImageUrl!), // Menggunakan NetworkImage
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _coverImageUrl == null || _coverImageUrl!.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 28, color: Colors.blue), // Ganti ikon
                              SizedBox(height: 4),
                              Text("Tambahkan URL Gambar Cover", style: TextStyle(color: Colors.black54)), // Ganti teks
                            ],
                          ),
                        )
                      : null, // Jika ada gambar, tidak perlu child lain
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "News Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text("Title*", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Select Category*",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              value: selectedCategory,
              items:
                  categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 20),
            const Text(
              "Add News/Article*",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Type News/Article Here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Add Tag*",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: tagController,
              decoration: InputDecoration(
                hintText: "Tag (pisahkan dengan koma)",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E73BE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          "Publish Now",
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
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
                  icon: const Icon(
                    Icons.how_to_vote_outlined,
                    color: Colors.white,
                  ),
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
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => Navigator.pushNamed(context, '/add'),
        backgroundColor: const Color(0xFF1E73BE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
