// lib/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/cart_manager.dart';
import 'cart_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isFavorite = false;
  bool _inCart = false;

  @override
  void initState() {
    super.initState();
    _inCart = CartManager.contains(widget.book.key);
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Favorilere eklendi! ❤️' : 'Favorilerden çıkarıldı'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleCart() {
    setState(() {
      if (_inCart) {
        CartManager.removeBook(widget.book.key);
        _inCart = false;
      } else {
        CartManager.addBook(widget.book);
        _inCart = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_inCart ? 'Sepete eklendi! 🛒' : 'Sepetten çıkarıldı'),
        duration: const Duration(seconds: 1),
        action: _inCart
            ? SnackBarAction(
                label: 'Sepete Git',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap Detayı'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: Icon(
              _inCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kapak
            Center(
              child: book.coverUrl != null
                  ? Image.network(
                      book.coverUrl!,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.menu_book,
                        size: 100,
                        color: Colors.brown,
                      ),
                    )
                  : const Icon(Icons.menu_book, size: 100, color: Colors.brown),
            ),
            const SizedBox(height: 20),

            // Başlık
            Text(
              book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Yazar
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.brown),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    book.authorsText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.brown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            // Yıl
            if (book.firstPublishYear != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'İlk Yayın: ${book.firstPublishYear}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],

            // Kategori
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  book.category,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sepete Ekle
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _toggleCart,
                icon: Icon(_inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
                label: Text(_inCart ? 'Sepetten Çıkar' : 'Sepete Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _inCart ? Colors.grey[700] : Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Favori
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.brown,
                ),
                label: Text(
                  _isFavorite ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
                  style: TextStyle(color: _isFavorite ? Colors.red : Colors.brown),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _isFavorite ? Colors.red : Colors.brown),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}