class Article {
  final String title;
  final String category;
  final String readTime;
  final String imageUrl;
  final bool isTrending;
  final List<String> tags;
  final String content;

  Article({
    required this.title,
    required this.category,
    required this.readTime,
    required this.imageUrl,
    this.isTrending = false,
    required this.tags,
    required this.content,
  });

  /// Digunakan saat mengirim data ke API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'readTime': readTime,
      'imageUrl': imageUrl,
      'isTrending': isTrending,
      'tags': tags,
      'content': content,
    };
  }

  /// Digunakan saat menerima data dari API
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      readTime: json['readTime'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isTrending: json['isTrending'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      content: json['content'] ?? '',
    );
  }
}
