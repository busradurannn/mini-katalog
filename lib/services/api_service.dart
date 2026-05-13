import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ApiService {
  static const String _url = 'https://wantapi.com/products.php';

  static Future<List<Product>> fetchProducts() async {
    try {
      if (kIsWeb) {
        return await _fetchWeb();
      } else {
        return await _fetchNative();
      }
    } catch (e) {
      debugPrint('API Hatası: $e');
      return [];
    }
  }

  static Future<List<Product>> _fetchNative() async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(_url));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    final Map<String, dynamic> decoded = json.decode(body);
    final List<dynamic> jsonList = decoded['data'];
    return jsonList.map((e) => Product.fromJson(e)).toList();
  }

  static Future<List<Product>> _fetchWeb() async {
    // Web için boş döndür, CORS engeli var
    return [];
  }
}