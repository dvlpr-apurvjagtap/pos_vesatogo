import 'package:flutter/foundation.dart';
import 'package:pos_vesatogo/features/pos/data/data_sources/product_local_source.dart';
import 'package:pos_vesatogo/features/pos/data/models/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductLocalSource _productSource = ProductLocalSource();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _productSource.getAllProducts();
      _applyFilters();
      print('Loaded ${_allProducts.length} products from Hive');
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set category filter
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Apply filters
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // Category filter
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      // Search filter
      final matchesSearch =
          _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Update product availability
  Future<void> updateProductAvailability(
    String productId,
    bool isAvailable,
  ) async {
    try {
      await _productSource.updateProductAvailability(productId, isAvailable);

      // Update local list
      final index = _allProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _allProducts[index] = Product(
          id: _allProducts[index].id,
          name: _allProducts[index].name,
          price: _allProducts[index].price,
          category: _allProducts[index].category,
          imageUrl: _allProducts[index].imageUrl,
          isAvailable: isAvailable,
          description: _allProducts[index].description,
        );
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating product availability: $e');
    }
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    if (category == 'All') return _allProducts;
    return _allProducts.where((p) => p.category == category).toList();
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
  }
}
