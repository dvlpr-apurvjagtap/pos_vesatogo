import 'package:hive/hive.dart';
import 'package:pos_vesatogo/features/pos/data/models/order_item.dart';
import 'package:pos_vesatogo/features/pos/data/models/customer.dart';
import 'package:pos_vesatogo/shared/enums/payment_method.dart';
import 'package:pos_vesatogo/shared/enums/order_status.dart';
import 'package:pos_vesatogo/shared/enums/order_type.dart';

part 'order.g.dart';

@HiveType(typeId: 2)
class Order extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<OrderItem> items;

  @HiveField(2)
  final double subtotal;

  @HiveField(3)
  final double tax;

  @HiveField(4)
  final double discount;

  @HiveField(5)
  final double tip;

  @HiveField(6)
  final double total;

  @HiveField(7)
  final String status; // Store as string for Hive compatibility

  @HiveField(8)
  final String paymentMethod; // Store as string

  @HiveField(9)
  final String orderType; // Store as string

  @HiveField(10)
  final Customer? customer;

  @HiveField(11)
  final String notes;

  @HiveField(12)
  final String tableNumber;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final bool isCredit;

  @HiveField(15)
  final bool isComplementary;

  @HiveField(16)
  final List<String> tokens;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.tip,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.orderType,
    this.customer,
    this.notes = '',
    required this.tableNumber,
    required this.createdAt,
    this.isCredit = false,
    this.isComplementary = false,
    this.tokens = const [],
  });

  OrderStatus get orderStatus => OrderStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => OrderStatus.created,
  );

  PaymentMethod get paymentMethodEnum => PaymentMethod.values.firstWhere(
    (e) => e.name == paymentMethod,
    orElse: () => PaymentMethod.cash,
  );

  OrderType get orderTypeEnum => OrderType.values.firstWhere(
    (e) => e.name == orderType,
    orElse: () => OrderType.dineIn,
  );

  String get orderNumber => id.substring(id.length - 4);

  String get displayOrderType {
    switch (orderType) {
      case 'dineIn':
        return 'Dine In';
      case 'takeAway':
        return 'Take Away';
      case 'delivery':
        return 'Delivery';
      default:
        return 'Dine In';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'tip': tip,
      'total': total,
      'status': status,
      'paymentMethod': paymentMethod,
      'orderType': orderType,
      'customer': customer?.toJson(),
      'notes': notes,
      'tableNumber': tableNumber,
      'createdAt': createdAt.toIso8601String(),
      'isCredit': isCredit,
      'isComplementary': isComplementary,
      'tokens': tokens,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      discount: json['discount'].toDouble(),
      tip: json['tip'].toDouble(),
      total: json['total'].toDouble(),
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      orderType: json['orderType'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      notes: json['notes'],
      tableNumber: json['tableNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      isCredit: json['isCredit'] ?? false,
      isComplementary: json['isComplementary'] ?? false,
      tokens: List<String>.from(json['tokens'] ?? []),
    );
  }
}
