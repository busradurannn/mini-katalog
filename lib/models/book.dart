// lib/models/book.dart
import 'package:flutter/material.dart';

class Book {
  final String key;
  final String title;
  final List<String> authors;
  final String? coverUrl;
  final int? firstPublishYear;
  final String category;

  const Book({
    required this.key,
    required this.title,
    required this.authors,
    this.coverUrl,
    this.firstPublishYear,
    required this.category,
  });

  // Open Library JSON'undan Book oluştur
  factory Book.fromJson(Map<String, dynamic> json, String category) {
    String? coverUrl;
    if (json['cover_i'] != null) {
      coverUrl = 'https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg';
    }

    List<String> authors = [];
    if (json['author_name'] != null) {
      authors = List<String>.from(json['author_name']);
    }

    return Book(
      key: json['key'] as String,
      title: json['title'] as String,
      authors: authors,
      coverUrl: coverUrl,
      firstPublishYear: json['first_publish_year'] as int?,
      category: category,
    );
  }

  // Yazar adlarını birleştirir
  String get authorsText {
    if (authors.isEmpty) return 'Bilinmiyor';
    if (authors.length == 1) return authors[0];
    return '${authors[0]} ve ${authors.length - 1} diğer';
  }
}