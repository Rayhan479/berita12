import 'package:flutter/material.dart';
import 'package:berita12/views/login_page.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int _currentPage = 0;

  final List<Map<String, String>> introData = [
    {
      "image": "assets/images/onboarding_1.png",
      "title": "Selamat Datang di Berita12",
      "desc":
          "Temukan berita terpercaya, terkini, dan terkurasi khusus untukmu",
    },
    {
      "image": "assets/images/onboarding_2.png",
      "title": "Konten Sesuai Minatmu",
      "desc":
          "Pilih kategori favorit dan dapatkan update berita yang kamu sukai",
    },
    {
      "image": "assets/images/onboarding_3.png",
      "title": "Aktifkan Notifikasi",
      "desc":
          "Aktifkan notifikasi agar selalu up-to-date dengan berita terbaru",
    },
  ];

  void _nextPage() {
    if (_currentPage < introData.length - 1) {
      setState(() => _currentPage++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void _skipIntro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Widget _buildDotIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            isActive
                ? Colors.white
                : Colors.white
                    .withRed(255)
                    .withGreen(255)
                    .withBlue(255)
                    .withAlpha((0.5 * 255).round()),

        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = introData[_currentPage];
    final blueColor = Color(0xFF2D5FAA);

    return Scaffold(
      backgroundColor: blueColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      item['title']!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      item['desc']!,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    Image.asset(
                      item['image']!,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  introData.length,
                  (index) => _buildDotIndicator(index),
                ),
              ),
              SizedBox(height: 32),

              // Ganti bagian Row tombol menjadi seperti ini:
              Row(
                children: [
                  if (_currentPage < introData.length - 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _skipIntro,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Lewati",
                          style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  if (_currentPage < introData.length - 1) SizedBox(width: 16),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: _nextPage,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentPage == introData.length - 1
                            ? "Mulai Sekarang"
                            : "Berikutnya",
                        style: TextStyle(
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
