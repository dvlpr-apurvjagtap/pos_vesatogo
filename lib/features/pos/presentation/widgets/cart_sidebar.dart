import 'package:flutter/material.dart';
import 'package:pos_vesatogo/core/constants/app_colors.dart';
import 'package:pos_vesatogo/features/pos/data/models/customer.dart';
import 'package:pos_vesatogo/features/pos/presentation/dialogs/add_customer_dialog.dart';
import 'package:pos_vesatogo/features/pos/presentation/dialogs/payment_dialog.dart';
import 'package:pos_vesatogo/features/pos/presentation/dialogs/running_orders_dialog.dart';
import 'package:pos_vesatogo/features/pos/providers/cart_provider.dart';
import 'package:pos_vesatogo/features/pos/data/models/cart_item.dart';
import 'package:provider/provider.dart';

class CartSidebar extends StatefulWidget {
  const CartSidebar({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<CartSidebar> createState() => _CartSidebarState();
}

class _CartSidebarState extends State<CartSidebar> {
  String? _selectedTable = 'T1';
  final List<String> _tables = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'];

  String _selectedOrderType = 'Dine In';
  String _selectedPayment = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildOrderTypeSection(),
          _buildOrderItems(), // Fixed: was _buildOrderItem()
          _buildNotesSection(),
          _buildPaymentSection(),
          _buildCheckoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          _buildOrderTypeButton('Dine In'),
          const SizedBox(width: 5),
          _buildOrderTypeButton('Take Away'),
          const SizedBox(width: 5),
          _buildOrderTypeButton('Delivery'),
          const SizedBox(width: 5),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedTable,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              items: _tables.map((table) {
                return DropdownMenuItem(
                  value: table,
                  child: Text(
                    '$table (Table)',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTable = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Update the _buildOrderTypeSection method in cart_sidebar.dart:

  Widget _buildOrderTypeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Customer section
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                if (cart.customer == null) {
                  // Show Add Customer button
                  return TextButton.icon(
                    onPressed: _showAddCustomerDialog,
                    icon: Icon(Icons.add, color: AppColors.primary, size: 18),
                    label: Text(
                      "Customer",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  );
                } else {
                  // Show customer info
                  return _buildCustomerInfo(cart.customer!);
                }
              },
            ),
          ),

          const SizedBox(width: 16),

          const Text(
            'Captain',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Add this method to build customer info display:
  Widget _buildCustomerInfo(Customer customer) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  customer.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  customer.mobile,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
          // Edit button
          GestureDetector(
            onTap: _showEditCustomerDialog,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(Icons.edit, size: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 4),
          // Remove button
          GestureDetector(
            onTap: _removeCustomer,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Add these methods to handle customer actions:
  void _showAddCustomerDialog() async {
    final customer = await showDialog<Customer>(
      context: context,
      builder: (context) => const AddCustomerDialog(),
    );

    if (customer != null) {
      context.read<CartProvider>().setCustomer(customer);
    }
  }

  void _showEditCustomerDialog() async {
    final currentCustomer = context.read<CartProvider>().customer;
    if (currentCustomer == null) return;

    final updatedCustomer = await showDialog<Customer>(
      context: context,
      builder: (context) => AddCustomerDialog(
        customer: currentCustomer,
      ), // Pass existing customer
    );

    if (updatedCustomer != null) {
      context.read<CartProvider>().setCustomer(updatedCustomer);
    }
  }

  void _removeCustomer() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Customer'),
        content: const Text(
          'Are you sure you want to remove the customer from this order?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CartProvider>().removeCustomer();
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeButton(String type) {
    final isSelected = _selectedOrderType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedOrderType = type),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          type,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    return Expanded(
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Product Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Total',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Order items - Using real cart data
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                if (cart.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Cart is empty',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Add items from the menu',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];
                    return _buildOrderItemFromCart(cartItem);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemFromCart(CartItem cartItem) {
    final product = cartItem.product;
    final Color color = _getProductColor(product.category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product icon
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_drink, color: color, size: 16),
          ),
          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '(${product.price.toStringAsFixed(0)} per unit)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Text(
                      '&Refundable',
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.info_outline, size: 12, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),

          // Quantity controls
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQtyButton(
                  Icons.remove,
                  () => context.read<CartProvider>().decrementQuantity(
                    product.id,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${cartItem.quantity.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                _buildQtyButton(
                  Icons.add,
                  () => context.read<CartProvider>().incrementQuantity(
                    product.id,
                  ),
                ),
              ],
            ),
          ),

          // Total and remove button
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  cartItem.lineTotal.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () =>
                      context.read<CartProvider>().removeItem(product.id),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 12, color: Colors.grey),
      ),
    );
  }

  Color _getProductColor(String category) {
    switch (category.toLowerCase()) {
      case 'beverages':
        return Colors.orange;
      case 'chat':
        return Colors.green;
      case 'aam ras':
        return Colors.amber;
      case 'drinking water':
        return Colors.blue;
      case 'dryfruit':
        return Colors.brown;
      case 'dryfruit mastani':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Add cooking instructions note (optional)',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(top: BorderSide(color: Colors.grey)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Base Amount Payable',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₹${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Payment',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPaymentButton('Cash'),
                  const SizedBox(width: 8),
                  _buildPaymentButton('Card'),
                  const SizedBox(width: 8),
                  _buildPaymentButton('Credit'),
                  const SizedBox(width: 8),
                  _buildPaymentButton('UPI'),
                  const SizedBox(width: 8),
                  _buildPaymentButton('Paytm'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentButton(String label) {
    final isSelected = _selectedPayment == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPayment = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  // In cart_sidebar.dart, update the checkout button:

  Widget _buildCheckoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (context) => const PaymentDialog(),
          );

          // If payment was successful, show running orders
          if (result == 'success') {
            await Future.delayed(const Duration(milliseconds: 500));
            showDialog(
              context: context,
              builder: (context) => const RunningOrdersDialog(),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Text(
          'Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
