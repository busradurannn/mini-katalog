import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _inCart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.image,
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 280,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported, size: 60),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.product.price} ₺',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(widget.product.category),
                    backgroundColor: Colors.deepPurple.shade50,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ürün Açıklaması',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _inCart = !_inCart;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _inCart
                                  ? '${widget.product.title} sepete eklendi!'
                                  : '${widget.product.title} sepetten çıkarıldı!',
                            ),
                            backgroundColor: Colors.deepPurple,
                          ),
                        );
                      },
                      icon: Icon(_inCart
                          ? Icons.remove_shopping_cart
                          : Icons.add_shopping_cart),
                      label: Text(_inCart ? 'Sepetten Çıkar' : 'Sepete Ekle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}