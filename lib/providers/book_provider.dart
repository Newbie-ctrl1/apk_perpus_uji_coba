import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  List<BookModel> _books = [];
  List<BookModel> get books => List.unmodifiable(_books);
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;

  BookProvider();

  Future<void> addBook(BookModel book) async {
    try {
      _books.add(book);
      await _saveBooks();
      notifyListeners();
    } catch (e) {
      _error = 'Gagal menambahkan buku: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBook(BookModel book) async {
    try {
      final index = _books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        _books[index] = book;
        await _saveBooks();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Gagal mengupdate buku: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      _books.removeWhere((book) => book.id == id);
      await _saveBooks();
      notifyListeners();
    } catch (e) {
      _error = 'Gagal menghapus buku: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _saveBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = _books.map((book) => book.toJson()).toList();
      await prefs.setString('books', jsonEncode(booksJson));
    } catch (e) {
      _error = 'Gagal menyimpan data buku: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadBooks() async {
    if (_isLoading) return;
    
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final booksString = prefs.getString('books');
      
      if (booksString != null && booksString.isNotEmpty) {
        try {
          final List<dynamic> decodedList = jsonDecode(booksString);
          _books = decodedList.map((item) => BookModel.fromJson(item)).toList();
        } catch (parseError) {
          _error = 'Format data buku tidak valid';
          _books = [];
          await prefs.remove('books'); // Reset invalid data
        }
      } else {
        _books = [];
      }
    } catch (e) {
      _error = 'Gagal memuat data buku: $e';
      _books = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<BookModel> searchBooks(String query) {
    if (query.isEmpty) return List.unmodifiable(_books);
    
    final lowercaseQuery = query.toLowerCase();
    return List.unmodifiable(_books.where((book) =>
      book.title.toLowerCase().contains(lowercaseQuery) ||
      book.author.toLowerCase().contains(lowercaseQuery) ||
      book.category.toLowerCase().contains(lowercaseQuery)
    ));
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
} 