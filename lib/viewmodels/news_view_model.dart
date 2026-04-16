import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsService _newsService = NewsService();

  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  List<Article> _favoriteArticles = [];

  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Article> get articles => _filteredArticles;
  List<Article> get favoriteArticles => _favoriteArticles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories => [
    'All',
    'Technology',
    'Business',
    'Sports',
    'Education',
    'Health',
  ];

  Future<void> initialize() async {
    await fetchArticles();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _articles = await _newsService.fetchArticles();
      await _loadFavorites();
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Lỗi tải dữ liệu: $e';
      _filteredArticles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshArticles() async {
    await fetchArticles();
  }

  void searchArticles(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Article> temp = List.from(_articles);

    if (_selectedCategory != 'All') {
      temp = temp.where((article) => article.category == _selectedCategory).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      temp = temp.where((article) {
        return article.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    _filteredArticles = temp;
  }

  bool isFavorite(Article article) {
    return _favoriteArticles.any((item) => item.id == article.id);
  }

  Future<void> toggleFavorite(Article article) async {
    if (isFavorite(article)) {
      _favoriteArticles.removeWhere((item) => item.id == article.id);
    } else {
      _favoriteArticles.add(article);
    }

    await _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = _favoriteArticles.map((e) => e.id).toList();
    await prefs.setString('favorite_ids', jsonEncode(favoriteIds));
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favorite_ids');

    if (data == null) {
      _favoriteArticles = [];
      return;
    }

    final List<dynamic> ids = jsonDecode(data);

    _favoriteArticles = _articles.where((article) => ids.contains(article.id)).toList();
  }
}