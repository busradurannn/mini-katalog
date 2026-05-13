// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/cart_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _removeBook(String key) {
    setState(() => CartManager.removeBook(key));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kitap sepetten kaldırıldı'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sepeti Temizle'),
        content: const Text('Tüm kitaplar sepetten kaldırılsın mı?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => CartManager.clear());
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearCart,
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Sepetiniz boş', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text(
                    'Kitap listesinden kitap ekleyebilirsiniz.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.brown[50],
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    '${cartItems.length} kitap sepetinizde',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final book = cartItems[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: book.coverUrl != null
                                ? Image.network(
                                    book.coverUrl!,
                                    width: 50,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.menu_book,
                                      size: 40,
                                      color: Colors.brown,
                                    ),
                                  )
                                : const Icon(Icons.menu_book, size: 40, color: Colors.brown),
                          ),
                          title: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                book.authorsText,
                                style: const TextStyle(color: Colors.brown, fontSize: 12),
                              ),
                              Text(
                                book.category,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeBook(book.key),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sipariş simülasyonu tamamlandı! 🎉'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Siparişi Tamamla (Simülasyon)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}