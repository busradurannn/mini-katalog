// lib/screens/book_list_screen.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'Roman';
  String _searchQuery = '';

  final List<String> _categories = [
    'Roman',
    'Bilim & Teknoloji',
    'Kişisel Gelişim',
    'Tarih',
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks('Roman');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks(String category) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchController.clear();
      _searchQuery = '';
    });

    final books = await ApiService.fetchBooks(category);

    setState(() {
      _isLoading = false;
      if (books.isEmpty) {
        _errorMessage = 'Kitap bulunamadı veya bağlantı hatası.';
      } else {
        _allBooks = books;
        _filteredBooks = books;
      }
    });
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _loadBooks(category);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredBooks = _searchQuery.isEmpty
          ? _allBooks
          : _allBooks.where((book) {
              return book.title.toLowerCase().contains(_searchQuery) ||
                  book.authors.any((a) => a.toLowerCase().contains(_searchQuery));
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitaplar'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Arama
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Kitap veya yazar ara...',
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.brown, width: 2),
                ),
                filled: true,
                fillColor: Colors.brown[50],
              ),
            ),
          ),

          // Kategori filtreleri
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => _onCategoryChanged(cat),
                  selectedColor: Colors.brown,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.brown[700],
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.brown[50],
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.brown),
            SizedBox(height: 12),
            Text('Kitaplar yükleniyor...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 12),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadBooks(_selectedCategory),
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredBooks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text('Kitap bulunamadı.'),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredBooks.length,
      itemBuilder: (context, index) {
        final book = _filteredBooks[index];
        return BookCard(
          book: book,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
            );
          },
        );
      },
    );
  }
}