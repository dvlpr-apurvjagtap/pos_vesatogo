import 'package:flutter/material.dart';
import 'package:pos_vesatogo/features/pos/presentation/widgets/product_card.dart';
import 'package:pos_vesatogo/features/pos/data/models/product.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required bool isCartOpen,
  }) : _isCartOpen = isCartOpen;

  final List<Product> products;
  final Function(Product) onProductTap;
  final bool _isCartOpen;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isCartOpen ? 4 : 6,
        // childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: product.isAvailable
              ? () => onProductTap(product)
              : null, // Pass product
        );
      },
    );
  }
}
