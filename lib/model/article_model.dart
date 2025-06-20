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
}
