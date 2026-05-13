import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ApiService {
  static const String _url = 'https://wantapi.com/products.php';

  static Future<List<Product>> fetchProducts() async {
    try {
      final body = await html.HttpRequest.getString(_url);
      final Map<String, dynamic> decoded = json.decode(body);
      final List<dynamic> jsonList = decoded['data'];
      return jsonList.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      debugPrint('API Hatası: $e');
      return [];
    }
  }
}