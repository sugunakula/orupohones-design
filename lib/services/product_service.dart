import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductService {
  final Dio _dio;

  ProductService() : _dio = Dio(BaseOptions(
    baseUrl: 'http://40.90.224.241:5000',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<List<Product>> fetchProducts({
    int page = 1,
    Map<String, dynamic>? filters,
    String? sortBy,
    int? sortOrder,
  }) async {
    try {

      final response = await _dio.post('/filter', data: {
        "filter": {
          ...?filters,
          "page": page,
          if (sortBy != null) "sort": {
            sortBy: sortOrder ?? -1,
          },
        }
      });


      if (response.statusCode == 200 && 
          response.data['data'] != null && 
          response.data['data']['data'] != null) {
        
        final products = (response.data['data']['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
        
        products.forEach((product) {
          print('Product: ${product.make} ${product.model} - ₹${product.price}');
        });
        
        return products;
      }
      print('No products found in response');
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
} 