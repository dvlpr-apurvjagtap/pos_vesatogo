import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_vesatogo/features/pos/data/models/product.dart';
import 'package:pos_vesatogo/features/pos/data/models/customer.dart';
import 'package:pos_vesatogo/features/pos/data/models/order.dart';
import 'package:pos_vesatogo/features/pos/data/models/order_item.dart';

class DatabaseService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register all adapters
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(OrderItemAdapter());
    Hive.registerAdapter(OrderAdapter());
  }

  static Future<void> clearAllData() async {
    await Hive.deleteBoxFromDisk('products');
    await Hive.deleteBoxFromDisk('orders');
  }
}
