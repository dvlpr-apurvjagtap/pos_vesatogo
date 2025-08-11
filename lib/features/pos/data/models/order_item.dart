import 'package:hive/hive.dart';

part 'order_item.g.dart';

@HiveType(typeId: 1)
class OrderItem extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double unitPrice;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final double lineTotal;

  @HiveField(5)
  final String category;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'lineTotal': lineTotal,
      'category': category,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      unitPrice: json['unitPrice'].toDouble(),
      quantity: json['quantity'],
      lineTotal: json['lineTotal'].toDouble(),
      category: json['category'],
    );
  }
}
