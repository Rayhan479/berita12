import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import 'package:berita12/model/article_model.dart';
// import 'package:image_picker/image_picker.dart'; // Tidak diperlukan jika hanya input URL

class EditNewsPage extends StatefulWidget {
  final Article article; // Menerima objek Article untuk diedit

  const EditNewsPage({super.key, required this.article});

  @override
  State<EditNewsPage> createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage> {
  String? _coverImageUrl;
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
  final TextEditingController imageUrlController =
      TextEditingController(); // Controller untuk input URL gambar
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  // final ImagePicker _picker = ImagePicker(); // Tidak diperlukan jika hanya input URL
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data dari artikel yang ada
    titleController.text = widget.article.title;
    contentController.text = widget.article.content;
    tagController.text = widget.article.tags.join(
      ', ',
    ); // Gabungkan tags menjadi string
    _coverImageUrl = widget.article.imageUrl;
    selectedCategory = widget.article.category;
    imageUrlController.text =
        widget.article.imageUrl; // Isi juga controller URL input
  }

  // Fungsi untuk menampilkan dialog input URL gambar
  Future<void> _showImageUrlInputDialog() async {
    String? newImageUrl = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Masukkan URL Gambar Cover Baru'),
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

  // Fungsi untuk mengupdate artikel
  void _updateArticle() async {
    setState(() => _isLoading = true);

    final String title = titleController.text;
    final String? category = selectedCategory;
    final String content = contentController.text;
    final String tagsText = tagController.text;
    final String? imageUrl = _coverImageUrl;

    if (title.isEmpty ||
        category == null ||
        content.isEmpty ||
        tagsText.isEmpty ||
        imageUrl == null ||
        imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan lengkapi semua data, termasuk URL gambar cover.',
          ),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Buat Map data yang akan dikirim ke API update
    final Map<String, dynamic> updatedData = {
      "title": title,
      "category": category,
      "readTime":
          widget
              .article
              .readTime, // Pertahankan readTime yang sudah ada atau hitung ulang
      "imageUrl": imageUrl,
      "tags": tagsText.split(',').map((e) => e.trim()).toList(),
      "content": content,
      // isTrending, likes, comments biasanya tidak diupdate dari halaman ini
    };

    try {
      await ApiService().updateArticle(
        widget.article.id,
        updatedData,
      ); // Panggil API updateArticle
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel berhasil diperbarui!')),
      );
      Navigator.pop(
        context,
        true,
      ); // Kembali ke halaman sebelumnya dengan hasil sukses
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui artikel: ${e.toString()}')),
      );
      if (kDebugMode) {
        print('Error updating article: $e');
      }
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
          "Edit News", // Judul berubah
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
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
                    image:
                        _coverImageUrl != null && _coverImageUrl!.isNotEmpty
                            ? DecorationImage(
                              image: NetworkImage(_coverImageUrl!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      _coverImageUrl == null || _coverImageUrl!.isEmpty
                          ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 28,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Ketuk untuk Mengubah Gambar Cover (URL)",
                                  style: TextStyle(color: Colors.black54),
                                ), // Teks disesuaikan
                              ],
                            ),
                          )
                          : null,
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
            Row(
              children: const [
                Icon(Icons.format_bold, size: 20),
                SizedBox(width: 12),
                Icon(Icons.format_list_bulleted, size: 20),
                SizedBox(width: 12),
                Icon(Icons.image, size: 20),
                SizedBox(width: 12),
                Icon(Icons.link, size: 20),
                SizedBox(width: 12),
                Icon(Icons.emoji_emotions_outlined, size: 20),
              ],
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
                onPressed:
                    _isLoading
                        ? null
                        : _updateArticle, // Memanggil _updateArticle
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
                          "Update Article",
                          style: TextStyle(color: Colors.white),
                        ), // Teks tombol berubah
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
