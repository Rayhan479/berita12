import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  String? selectedCategory;
  final List<String> categories = ["Teknologi", "Politik", "Science", "Olahraga"];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Tahap 1: AppBar
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
            // ✅ Tahap 2: Area Cover Photo
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: [6, 3],
              color: Colors.grey,
              strokeWidth: 1.5,
              child: Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 28, color: Colors.blue),
                      SizedBox(height: 4),
                      Text("Add Cover Photos", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Tahap 3: News Details
            const Text("News Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),

            const Text("Title*", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 16),

            const Text("Select Category*", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select Category",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              value: selectedCategory,
              items: categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 20),

            // ✅ Tahap 4: Editor Artikel
            const Text("Add News/Article*", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),

            // Toolbar sederhana
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

            // Multiline textfield
            TextField(
              controller: contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Type News/Article Here...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Tahap 5: Tag
            const Text("Add Tag*", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: tagController,
              decoration: InputDecoration(
                hintText: "Tag",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Tahap 6: Tombol Publis Now
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E73BE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text("Publis Now", style: TextStyle(color: Colors.white),),
              ),
            ),
            const SizedBox(height: 70), // agar tidak tertutup navbar
          ],
        ),
      ),

      // ✅ Tahap 7: Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: const Color(0xFF1E73BE),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    icon: const Icon(Icons.home_outlined, color: Colors.white)),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/bookmark');
                    },
                    icon: const Icon(Icons.bookmark_border, color: Colors.white)),
                const SizedBox(width: 40), // space for FAB
                IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.article_outlined, color: Colors.white)),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    icon: const Icon(Icons.person_outline, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        tooltip: "Add News",
        backgroundColor: const Color(0xFF1E73BE),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
