import 'package:hive/hive.dart';
import 'package:pos_vesatogo/features/pos/data/models/product.dart';

class ProductLocalSource {
  static const String _boxName = 'products';

  Future<void> seedProductsIfEmpty() async {
    final box = await Hive.openBox<Product>(_boxName);

    if (box.isEmpty) {
      final products = _getDummyProducts();

      for (final product in products) {
        await box.put(product.id, product);
      }

      print('Seeded ${products.length} products into Hive');
    } else {
      print('Products already exist in Hive (${box.length} items)');
    }
  }

  Future<List<Product>> getAllProducts() async {
    final box = await Hive.openBox<Product>(_boxName);
    return box.values.toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final box = await Hive.openBox<Product>(_boxName);
    return box.values
        .where(
          (product) => product.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  // Update product availability
  Future<void> updateProductAvailability(
    String productId,
    bool isAvailable,
  ) async {
    final box = await Hive.openBox<Product>(_boxName);
    final product = box.get(productId);

    if (product != null) {
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        price: product.price,
        category: product.category,
        imageUrl: product.imageUrl,
        isAvailable: isAvailable,
        description: product.description,
      );
      await box.put(productId, updatedProduct);
    }
  }

  // Add new product
  Future<void> addProduct(Product product) async {
    final box = await Hive.openBox<Product>(_boxName);
    await box.put(product.id, product);
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    final box = await Hive.openBox<Product>(_boxName);
    await box.delete(productId);
  }

  // Dummy products data
  List<Product> _getDummyProducts() {
    return [
      // Beverages
      Product(
        id: 'bev_001',
        name: 'Mango Juice',
        price: 70.0,
        category: 'Beverages',
        isAvailable: true,
        description: 'Fresh mango juice',
      ),
      Product(
        id: 'bev_002',
        name: 'Watermelon Juice',
        price: 70.0,
        category: 'Beverages',
        isAvailable: true,
        description: 'Fresh watermelon juice',
      ),
      Product(
        id: 'bev_003',
        name: 'Orange Juice',
        price: 65.0,
        category: 'Beverages',
        isAvailable: false, // Out of stock
        description: 'Fresh orange juice',
      ),
      Product(
        id: 'bev_004',
        name: 'Apple Juice',
        price: 75.0,
        category: 'Beverages',
        isAvailable: true,
        description: 'Fresh apple juice',
      ),

      // Chat
      Product(
        id: 'chat_001',
        name: 'Pani Puri',
        price: 50.0,
        category: 'Chat',
        isAvailable: true,
        description: 'Traditional pani puri',
      ),
      Product(
        id: 'chat_002',
        name: 'Bhel Puri',
        price: 60.0,
        category: 'Chat',
        isAvailable: true,
        description: 'Mumbai style bhel puri',
      ),
      Product(
        id: 'chat_003',
        name: 'Sev Puri',
        price: 55.0,
        category: 'Chat',
        isAvailable: false,
        description: 'Crispy sev puri',
      ),

      // Aam Ras
      Product(
        id: 'aamras_001',
        name: 'Alphonso Aam Ras',
        price: 120.0,
        category: 'Aam ras',
        isAvailable: true,
        description: 'Pure alphonso mango pulp',
      ),
      Product(
        id: 'aamras_002',
        name: 'Keshar Aam Ras',
        price: 150.0,
        category: 'Aam ras',
        isAvailable: true,
        description: 'Aam ras with saffron',
      ),

      // Drinking Water
      Product(
        id: 'water_001',
        name: 'Mineral Water 500ml',
        price: 20.0,
        category: 'Drinking Water',
        isAvailable: true,
        description: 'Packaged drinking water',
      ),
      Product(
        id: 'water_002',
        name: 'Mineral Water 1L',
        price: 35.0,
        category: 'Drinking Water',
        isAvailable: true,
        description: 'Large bottle mineral water',
      ),

      // Dryfruit
      Product(
        id: 'dry_001',
        name: 'Mixed Dryfruit',
        price: 200.0,
        category: 'Dryfruit',
        isAvailable: true,
        description: 'Premium mixed dry fruits',
      ),
      Product(
        id: 'dry_002',
        name: 'Cashew Nuts',
        price: 350.0,
        category: 'Dryfruit',
        isAvailable: true,
        description: 'Premium cashew nuts',
      ),

      // Dryfruit Mastani
      Product(
        id: 'mastani_001',
        name: 'Dry Fruit Mastani',
        price: 180.0,
        category: 'Dryfruit Mastani',
        isAvailable: true,
        description: 'Rich dry fruit mastani',
      ),
      Product(
        id: 'mastani_002',
        name: 'Badam Mastani',
        price: 160.0,
        category: 'Dryfruit Mastani',
        isAvailable: true,
        description: 'Almond flavored mastani',
      ),
    ];
  }
}
