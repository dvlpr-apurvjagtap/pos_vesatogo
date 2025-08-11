import 'package:flutter/foundation.dart';
import 'package:pos_vesatogo/features/pos/data/data_sources/order_local_source.dart';
import 'package:pos_vesatogo/features/pos/data/models/order.dart';
import 'package:pos_vesatogo/features/pos/data/models/order_item.dart';
import 'package:pos_vesatogo/features/pos/providers/cart_provider.dart';
import 'dart:math';

class OrderProvider with ChangeNotifier {
  final OrderLocalSource _orderSource = OrderLocalSource();

  List<Order> _runningOrders = [];
  List<Order> _completedOrders = [];
  bool _isLoading = false;

  List<Order> get runningOrders => _runningOrders;
  List<Order> get completedOrders => _completedOrders;
  bool get isLoading => _isLoading;

  // Create order from cart
  Future<String> createOrderFromCart(
    CartProvider cart, {
    double discount = 0,
    double tip = 0,
    bool isCredit = false,
    bool isComplementary = false,
  }) async {
    if (cart.isEmpty) throw Exception('Cart is empty');

    // Generate order ID and tokens
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final tokens = _generateTokens(cart.items.length);

    // Convert cart items to order items
    final orderItems = cart.items.map((cartItem) {
      return OrderItem(
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        unitPrice: cartItem.product.price,
        quantity: cartItem.quantity,
        lineTotal: cartItem.lineTotal,
        category: cartItem.product.category,
      );
    }).toList();

    // Calculate totals
    final subtotal = cart.subtotal;
    final tax = subtotal * 0.05;
    final total = subtotal + tax + tip - discount;

    // Create order
    final order = Order(
      id: orderId,
      items: orderItems,
      subtotal: subtotal,
      tax: tax,
      discount: discount,
      tip: tip,
      total: total,
      status: 'created',
      paymentMethod: cart.paymentMethod?.name ?? 'cash',
      orderType: cart.orderType.toLowerCase().replaceAll(' ', ''),
      customer: cart.customer,
      notes: cart.notes,
      tableNumber: cart.selectedTable,
      createdAt: DateTime.now(),
      isCredit: isCredit,
      isComplementary: isComplementary,
      tokens: tokens,
    );

    // Save order
    final savedOrderId = await _orderSource.saveOrder(order);

    // Refresh orders list
    await loadRunningOrders();

    return savedOrderId;
  }

  // Load running orders
  Future<void> loadRunningOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _runningOrders = await _orderSource.getRunningOrders();
      _runningOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error loading running orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load completed orders
  Future<void> loadCompletedOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _completedOrders = await _orderSource.getCompletedOrders();
      _completedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error loading completed orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orderSource.updateOrderStatus(orderId, status);
    await loadRunningOrders();
    await loadCompletedOrders();
  }

  // Generate random tokens
  List<String> _generateTokens(int count) {
    final random = Random();
    final tokens = <String>[];
    for (int i = 0; i < count; i++) {
      tokens.add((10 + random.nextInt(90)).toString());
    }
    return tokens;
  }
}
