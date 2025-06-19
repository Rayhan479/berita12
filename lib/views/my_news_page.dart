import 'package:flutter/material.dart';

class MyNewsPage extends StatelessWidget {
  const MyNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======= BottomAppBar + FAB =======
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF1E73BE),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
          child: SizedBox(
            height: 40, // Ubah jadi 40 agar icon terlihat
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
                const SizedBox(width: 10), // Ruang untuk FAB
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/mynews');
                  },
                  icon: const Icon(Icons.how_to_vote, color: Colors.white),
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

      // ======= Body Utama =======
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
                  const Text(
                    'My News',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    TabItem(label: 'Trending', isActive: true),
                    TabItem(label: 'All'),
                    TabItem(label: 'Latest'),
                    TabItem(label: 'Teknologi'),
                    TabItem(label: 'Science'),
                    TabItem(label: 'Politik'),
                  ],
                ),
              ),
            ),

            // Daftar Berita
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const NewsCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

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
            child: Image.asset(
              'assets/images/berita.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wow USA Develops news way faster ....',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
