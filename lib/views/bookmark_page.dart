import 'package:flutter/material.dart';

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
    "Politik"
  ];

  final List<Map<String, String>> _beritaList = [
    {
      'title': 'Wow USA Develops news way faster ....',
      'image': 'https://image.idntimes.com/post/20191216/2-9d35e61e811b05aec40f694b1c1cc187.jpg?tr=w-1920,f-webp,q-75&width=1920&format=webp&quality=75',
      'likes': '316K',
      'comments': '110K'
    },
    {
      'title': 'Wow USA Develops news way faster ....',
      'image': 'https://cdn1.katadata.co.id/media/images/thumb/2025/04/24/BytePlus-2025_04_24-19_38_38_ac9eaf82bceb2d35497b001e844b0058_960x640_thumb.jpeg',
      'likes': '316K',
      'comments': '110K'
    },
    {
      'title': 'Wow USA Develops news way faster ....',
      'image': 'https://media.licdn.com/dms/image/D5612AQHVP143zP7nLg/article-cover_image-shrink_720_1280/0/1686807804814?e=2147483647&v=beta&t=S8NCUTpngKg2mYOSklk6rwyFLicGCHBnu1ZQ5gj3NbM',
      'likes': '316K',
      'comments': '110K'
    },
  ];

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
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
                // Row with logo, title, and filter icon
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0x4D1E73BE),
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle
                        ),
                        child: const Icon(Icons.filter_list_rounded,
                          color: Color(0xFF1E73BE),),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Search bar
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
          // Tab Bar
          TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),

          // List Berita
          Expanded(
            child: ListView.builder(
              itemCount: _beritaList.length,
              itemBuilder: (context, index) {
                final berita = _beritaList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            berita['image']!,
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                berita['title']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.thumb_up_alt_outlined,
                                      size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(berita['likes']!),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.chat_bubble_outline,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(berita['comments']!),
                                  const Spacer(),
                                  const Icon(Icons.bookmark,
                                      color: Colors.blue),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      // Bottom NavBar
      bottomNavigationBar: BottomAppBar(
  shape: const CircularNotchedRectangle(),
  color: const Color(0xFF1E73BE),
  notchMargin: 8,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0), // Atur padding di sini
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
              Navigator.pushNamed(context, '/bookmark');
            },
            icon: const Icon(Icons.bookmark, color: Colors.white),
          ),
          const SizedBox(width: 10), // ruang untuk FAB
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.how_to_vote_outlined, color: Colors.white),
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
        onPressed: () {},
        backgroundColor: Color(0xFF1E73BE),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
