import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../models/product.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final ProductService _productService;
  BuildContext? _context;
  
  AuthViewModel(this._authService) : _productService = ProductService();
  
  void setContext(BuildContext context) {
    _context = context;
  }

  BuildContext? get currentContext => _context;
  
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  
  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;

  Map<String, dynamic>? _userData;
  String? get userName => _userData?['user']?['userName'];
  bool get isLoggedIn => _userData?['isLoggedIn'] == true;

  List<Product> _products = [];
  List<Product> get products => _products;
  
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  
  int _currentPage = 1;
  bool _hasMoreProducts = true;
  Set<String> _likedProductIds = {};

  void _updateLikedProducts(List<dynamic> likedListings) {
    _likedProductIds = Set.from(likedListings.map((e) => e.toString()));
    notifyListeners();
  }

  Future<void> initialize() async {
    setBusy(true);
    
    // Check stored login state
    final userData = await _authService.checkLoginStatus();
    if (userData != null) {
      _userData = userData;
      final likedListings = userData['user']?['favListings'] as List? ?? [];
      _updateLikedProducts(likedListings);
    }
    
    await loadInitialProducts();
    setBusy(false);
  }

  Future<bool> createOtp(String phoneNumber) async {
    setBusy(true);
    _phoneNumber = phoneNumber;  // Store the phone number
    final result = await _authService.createOtp(phoneNumber);
    setBusy(false);
    return result;
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    setBusy(true);
    final result = await _authService.verifyOtp(phoneNumber, otp);
    
    if (result) {
      final userData = await _authService.checkLoginStatus();
      if (userData != null) {
        _userData = userData;
        _isNewUser = userData['user']?['userName'] == null;
        final likedListings = userData['user']?['favListings'] as List? ?? [];
        _updateLikedProducts(likedListings);
      }
    }
    
    setBusy(false);
    return result;
  }

  Future<bool> updateUserName(String name) async {
    setBusy(true);
    // Try to get fresh token before updating name
    await _authService.checkLoginStatus();
    final result = await _authService.updateUserName(name);
    setBusy(false);
    return result;
  }

  Future<Map<String, dynamic>?> checkLoginStatus() async {
    setBusy(true);
    final result = await _authService.checkLoginStatus();
    if (result != null) {
      _isNewUser = result['userName'] == null;
    }
    setBusy(false);
    return result;
  }

  Future<bool> logout() async {
    setBusy(true);
    final result = await _authService.logout();
    if (result) {
      _userData = null;
      _likedProductIds.clear();
    }
    setBusy(false);
    return result;
  }

  Future<void> loadInitialProducts() async {
    print('Loading initial products...');
    setBusy(true);
    _products = await _productService.fetchProducts(page: 1);
    _currentPage = 1;
    _hasMoreProducts = _products.isNotEmpty;
    print('Initial products loaded: ${_products.length}');
    setBusy(false);
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts) {
      print('Skip loading more: isLoading=$_isLoadingMore, hasMore=$_hasMoreProducts');
      return;
    }

    print('Loading more products, page: ${_currentPage + 1}');
    _isLoadingMore = true;
    notifyListeners();

    try {
      final newProducts = await _productService.fetchProducts(page: _currentPage + 1);
      
      if (newProducts.isEmpty) {
        print('No more products available');
        _hasMoreProducts = false;
      } else {
        print('Loaded ${newProducts.length} more products');
        _products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      print('Error loading more products: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  bool isProductLiked(String productId) {
    return _likedProductIds.contains(productId);
  }

  Future<void> toggleLike(String productId) async {
    if (!isLoggedIn) return;

    final currentlyLiked = _likedProductIds.contains(productId);
    
    // Optimistic update
    if (currentlyLiked) {
      _likedProductIds.remove(productId);
    } else {
      _likedProductIds.add(productId);
    }
    notifyListeners();

    // Make API call
    final success = await _authService.toggleProductLike(productId, !currentlyLiked);
    
    if (!success) {
      // Revert if failed
      if (currentlyLiked) {
        _likedProductIds.add(productId);
      } else {
        _likedProductIds.remove(productId);
      }
      notifyListeners();
    }
  }
} 