import 'package:hive/hive.dart';
import 'package:pos_vesatogo/features/pos/data/models/order.dart';

class OrderLocalSource {
  static const String _boxName = 'orders';

  Future<String> saveOrder(Order order) async {
    final box = await Hive.openBox<Order>(_boxName);
    await box.put(order.id, order);
    print('Order ${order.orderNumber} saved to Hive');
    return order.id;
  }

  Future<List<Order>> getAllOrders() async {
    final box = await Hive.openBox<Order>(_boxName);
    return box.values.toList();
  }

  Future<List<Order>> getRunningOrders() async {
    final box = await Hive.openBox<Order>(_boxName);
    return box.values
        .where(
          (order) =>
              order.status == 'created' ||
              order.status == 'preparing' ||
              order.status == 'ready',
        )
        .toList();
  }

  Future<List<Order>> getCompletedOrders() async {
    final box = await Hive.openBox<Order>(_boxName);
    return box.values
        .where(
          (order) => order.status == 'completed' || order.status == 'cancelled',
        )
        .toList();
  }

  Future<List<Order>> getOrdersByDate(DateTime date) async {
    final box = await Hive.openBox<Order>(_boxName);
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return box.values
        .where(
          (order) =>
              order.createdAt.isAfter(startOfDay) &&
              order.createdAt.isBefore(endOfDay),
        )
        .toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final box = await Hive.openBox<Order>(_boxName);
    final order = box.get(orderId);
    if (order != null) {
      final updatedOrder = Order(
        id: order.id,
        items: order.items,
        subtotal: order.subtotal,
        tax: order.tax,
        discount: order.discount,
        tip: order.tip,
        total: order.total,
        status: status,
        paymentMethod: order.paymentMethod,
        orderType: order.orderType,
        customer: order.customer,
        notes: order.notes,
        tableNumber: order.tableNumber,
        createdAt: order.createdAt,
        isCredit: order.isCredit,
        isComplementary: order.isComplementary,
        tokens: order.tokens,
      );
      await box.put(orderId, updatedOrder);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    final box = await Hive.openBox<Order>(_boxName);
    await box.delete(orderId);
  }
}
