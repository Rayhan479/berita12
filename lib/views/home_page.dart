import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:berita12/views/profile_page.dart';

void main() {
  runApp(
    const MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
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
  final List<Map<String, dynamic>> _beritaList = List.generate(
    3,
    (index) => {
      'image': 'assets/images/berita.png',
      'title': 'Wow USA Develops news way faster ....',
      'likes': '316K',
      'comments': '110K',
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
            Image.asset('assets/images/logo_berita12.png', height: 60),
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
                color: Color(0x4D1E73BE),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Color(0xFF1E73BE),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _beritaList.length + 2, // +2 untuk TabBar & Carousel
        itemBuilder: (context, index) {
          if (index == 0) {
            // 1. Tab Bar
            return TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            );
          } else if (index == 1) {
            // 2. Carousel Slider
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CarouselSlider(
                items:
                    _carouselImages.asMap().entries.map((entry) {
                      String url = entry.value;
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
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
                                        color:
                                            _currentIndex == e.key
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
            // 3. List berita
            final berita =
                _beritaList[index - 2]; // offset -2 karena TabBar & Carousel
            return Card(
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
                        berita['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            berita['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
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
                              Text(berita['likes']),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.chat_bubble_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(berita['comments']),
                              const Spacer(),
                              const Icon(
                                Icons.bookmark_border,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF1E73BE),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_outline, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 48), // space for the FAB
            IconButton(
              icon: const Icon(Icons.poll, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Color(0xFF1E73BE),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}
