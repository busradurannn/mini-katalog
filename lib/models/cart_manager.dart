// lib/models/cart_manager.dart
import 'book.dart';

class CartManager {
  static final List<Book> items = [];

  static void addBook(Book book) {
    final alreadyAdded = items.any((b) => b.key == book.key);
    if (!alreadyAdded) items.add(book);
  }

  static void removeBook(String key) {
    items.removeWhere((b) => b.key == key);
  }

  static bool contains(String key) {
    return items.any((b) => b.key == key);
  }

  static void clear() {
    items.clear();
  }
}