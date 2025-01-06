import '../models/product.dart';
import '../services/api_client.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<Product>> getProducts() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // When ready for real API:
      // final response = await _apiClient.get('/products');
      // return (response['data'] as List).map((json) => Product.fromJson(json)).toList();

      // Return mock data
      return [
        Product(
          id: '1',
          companyId: '1',
          productName: 'Premium Widget',
          description: 'High-quality widget for all your needs',
          price: 99.99,
          sku: 'WDG-001',
          image: 'https://example.com/widget.jpg',
          quantity: 50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        // Add more mock products as needed
      ];
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // When ready for real API:
      // final response = await _apiClient.post('/products', product.toJson());
      // return response['success'] ?? false;

      return true;
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // When ready for real API:
      // final response = await _apiClient.put('/products/${product.id}', product.toJson());
      // return response['success'] ?? false;
      
      return true;
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
