import 'package:flutter/material.dart';

class Article {
  final String id;
  final String title;
  final String category;
  final String readTime;
  final String imageUrl;
  final bool isTrending;
  final List<String> tags;
  final String content;
  final bool? isBookmarked;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.imageUrl,
    this.isTrending = false,
    required this.tags,
    required this.content, 
    this.isBookmarked,
  });

  /// Digunakan saat mengirim data ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'readTime': readTime,
      'imageUrl': imageUrl,
      'isTrending': isTrending,
      'tags': tags,
      'content': content,
      
    };
  }

<<<<<<< HEAD
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
=======
  factory Article.fromJson(Map<String, dynamic> json) {
  return Article(
    id: json['id'] ?? UniqueKey().toString(),
    title: json['title'],
    category: json['category'],
    imageUrl: json['imageUrl'],
    content: json['content'],
    tags: List<String>.from(json['tags'] ?? []), 
    readTime: json['readTime'], 
    isBookmarked: json['isBookmarked'] ?? false,
    // tambahkan field lainnya jika diperlukan
  );
}

  





>>>>>>> 84cfed050d0b1a0fa5ed366cfaef85d44f8f06b9
}
