import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data berita
    final List<Map<String, String>> beritaList = [
      {
        'judul': 'Berita Pertama',
        'deskripsi': 'Ini deskripsi singkat berita pertama.',
      },
      {
        'judul': 'Berita Kedua',
        'deskripsi': 'Ini deskripsi singkat berita kedua.',
      },
      {
        'judul': 'Berita Ketiga',
        'deskripsi': 'Ini deskripsi singkat berita ketiga.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita12'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: beritaList.length,
        itemBuilder: (context, index) {
          final berita = beritaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(berita['judul'] ?? ''),
              subtitle: Text(berita['deskripsi'] ?? ''),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Aksi ketika berita diklik, nanti bisa diarahkan ke detail
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Klik: ${berita['judul']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}