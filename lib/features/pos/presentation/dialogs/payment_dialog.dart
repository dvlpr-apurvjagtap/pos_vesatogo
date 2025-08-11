import 'package:flutter/material.dart';
import 'package:pos_vesatogo/core/constants/app_colors.dart';
import 'package:pos_vesatogo/features/pos/presentation/dialogs/running_orders_dialog.dart';
import 'package:pos_vesatogo/features/pos/providers/cart_provider.dart';
import 'package:pos_vesatogo/features/pos/providers/order_provider.dart';
import 'package:pos_vesatogo/shared/enums/payment_method.dart';
import 'package:provider/provider.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  PaymentMethod _selectedPayment = PaymentMethod.cash;
  final _discountController = TextEditingController();
  final _tipController = TextEditingController();
  bool _isCredit = false;
  bool _isComplementaryBill = false;

  @override
  void dispose() {
    _discountController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderTypeSection(),
                    const SizedBox(height: 16),
                    _buildAmountSection(),
                    const SizedBox(height: 16),
                    _buildPaymentMethodSection(),
                    const SizedBox(height: 16),
                    _buildOrderSummary(),
                    const SizedBox(height: 16),
                    _buildDiscountAndTip(),
                    const SizedBox(height: 16),
                    _buildTotalSection(),
                    const SizedBox(height: 16),
                    _buildComplementaryBill(),
                    const SizedBox(height: 24),
                    _buildPayButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeSection() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                cart.orderType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Text(
                  'Credit',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: _isCredit,
                    onChanged: (value) {
                      setState(() {
                        _isCredit = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAmountSection() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount Payable',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              Text(
                '₹${cart.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PaymentMethod.values.map((method) {
            return _buildPaymentMethodButton(method);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodButton(PaymentMethod method) {
    final isSelected = _selectedPayment == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = method;
        });
      },
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              _getPaymentIcon(method),
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              method.displayName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.credit:
        return Icons.account_balance;
      case PaymentMethod.upi:
        return Icons.qr_code;
      case PaymentMethod.paytm:
        return Icons.phone_android;
      case PaymentMethod.others:
        return Icons.more_horiz;
    }
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Column(
          children: [
            _SummaryRow(label: 'Item(s)', value: '${cart.items.length}'),
            _SummaryRow(label: 'Qty', value: '${cart.itemCount}'),
            _SummaryRow(
              label: 'IGST (2.5%)',
              value: '₹${(cart.subtotal * 0.025).toStringAsFixed(2)}',
            ),
            _SummaryRow(
              label: 'SCST (2.5%)',
              value: '₹${(cart.subtotal * 0.025).toStringAsFixed(2)}',
            ),
            _SummaryRow(label: 'Tax', value: '₹${cart.tax.toStringAsFixed(2)}'),
          ],
        );
      },
    );
  }

  Widget _buildDiscountAndTip() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Add Discount ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Text(
              '%',
              style: TextStyle(fontSize: 14, color: Colors.orange),
            ),
            const Spacer(),
            SizedBox(
              width: 80,
              height: 32,
              child: TextField(
                controller: _discountController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '₹ 0.00',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Add Tip/Clarity',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            SizedBox(
              width: 80,
              height: 32,
              child: TextField(
                controller: _tipController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '₹ 0.00',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final discount = double.tryParse(_discountController.text) ?? 0;
        final tip = double.tryParse(_tipController.text) ?? 0;
        final grandTotal = cart.total + tip - discount;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE0E0E0)),
              bottom: BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComplementaryBill() {
    return Row(
      children: [
        const Text(
          'Complementary Bill',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: _isComplementaryBill,
            onChanged: (value) {
              setState(() {
                _isComplementaryBill = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: cart.isEmpty
                ? null
                : () => _handlePayment(context, cart),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Pay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handlePayment(BuildContext context, CartProvider cart) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get discount and tip values
      final discount = double.tryParse(_discountController.text) ?? 0;
      final tip = double.tryParse(_tipController.text) ?? 0;

      // Set payment method in cart
      cart.setPaymentMethod(_selectedPayment);

      // Create order
      final orderId = await context.read<OrderProvider>().createOrderFromCart(
        cart,
        discount: discount,
        tip: tip,
        isCredit: _isCredit,
        isComplementary: _isComplementaryBill,
      );

      // Clear cart
      cart.clear();

      // Close loading dialog
      Navigator.of(context).pop();

      // Close payment dialog with success result
      Navigator.of(context).pop('success');

      // Show success and running orders - use the original context from the parent
      _showSuccessAndOrders(context, orderId);
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessAndOrders(BuildContext context, String orderId) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order placed successfully! Order #${orderId.substring(orderId.length - 4)}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Show running orders dialog after a brief delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const RunningOrdersDialog(),
        );
      }
    });
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
