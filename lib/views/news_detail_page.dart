import 'package:flutter/material.dart';
import '../model/article_model.dart' as model;

class NewsDetailPage extends StatelessWidget {
  final model.Article article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff1E73BE)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0x4D1E73BE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.share, color: Color(0xff1E73BE)),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0x4D1E73BE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bookmark_border, color: Color(0xff1E73BE)),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                article.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff1E73BE)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(color: Color(0xff1E73BE)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.thumb_up, size: 16, color: Color(0xff1E73BE)),
                  const SizedBox(width: 4),
                  Text('120'),
                  const SizedBox(width: 12),
                  const Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xff1E73BE)),
                  const SizedBox(width: 4),
                  Text('20'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                article.content,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 24),
            if (article.tags.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text('Show All'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: article.tags.map((tag) {
                    return Chip(
                      label: Text(
                        '#$tag',
                        style: const TextStyle(color: Color(0xff1e73be)),
                      ),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xff1E73BE)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}