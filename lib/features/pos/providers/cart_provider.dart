import 'package:flutter/foundation.dart';
import 'package:pos_vesatogo/features/pos/data/models/product.dart';
import 'package:pos_vesatogo/features/pos/data/models/cart_item.dart';
import 'package:pos_vesatogo/features/pos/data/models/customer.dart';
import 'package:pos_vesatogo/shared/enums/payment_method.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  Customer? _customer;
  PaymentMethod? _paymentMethod;
  String _orderType = 'Dine In';
  String _selectedTable = 'T1';
  String _notes = '';

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  Customer? get customer => _customer;
  PaymentMethod? get paymentMethod => _paymentMethod;
  String get orderType => _orderType;
  String get selectedTable => _selectedTable;
  String get notes => _notes;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Calculations
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.lineTotal);
  double get tax => subtotal * 0.05; // 5% tax
  double get total => subtotal + tax;

  // Add product to cart
  void addProduct(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Product already exists, increment quantity
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      // Add new product to cart
      _items.add(CartItem(product: product, quantity: 1));
    }

    notifyListeners();
    print('Added ${product.name} to cart. Total items: ${_items.length}');
  }

  // Increment quantity
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  // Decrement quantity
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final currentQuantity = _items[index].quantity;
      if (currentQuantity > 1) {
        _items[index] = _items[index].copyWith(quantity: currentQuantity - 1);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Remove item completely
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Set customer
  void setCustomer(Customer? customer) {
    _customer = customer;
    notifyListeners();
    if (customer != null) {
      print('Customer set: ${customer.displayName} (${customer.mobile})');
    } else {
      print('Customer removed');
    }
  }

  void removeCustomer() {
    _customer = null;
    notifyListeners();
  }

  // Set payment method
  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // Set order type
  void setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }

  // Set table
  void setTable(String table) {
    _selectedTable = table;
    notifyListeners();
  }

  // Set notes
  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  // Clear cart
  void clear() {
    _items.clear();
    _customer = null;
    _paymentMethod = null;
    _orderType = 'Dine In';
    _selectedTable = 'T1';
    _notes = '';
    notifyListeners();
  }

  // Get quantity for a specific product
  int getQuantityForProduct(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: Product(id: '', name: '', price: 0, category: ''),
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}
