import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../models/order_model.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';
import '../home/home_screen.dart';
import '../orders/order_screens.dart';
import 'address_payment_screens.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final profile = Get.find<ProfileController>();
    final orderController = Get.find<OrderController>();
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            const _StepHeader(
              number: '01',
              title: 'Delivery Address',
              subtitle: 'Where your package will be delivered',
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Get.to(() => const AddressManagementScreen()),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorder : AppTheme.border,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isDark
                          ? const Color(0xFF1E284A)
                          : const Color(0xFFEEF2FF),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppTheme.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.address.value,
                            style: TextStyle(
                              color: AppTheme.subtleColor(context),
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.phone.value,
                            style: TextStyle(
                              color: AppTheme.subtleColor(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.subtleColor(context),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const _StepHeader(
              number: '02',
              title: 'Payment Method',
              subtitle: 'Demo payment simulated securely',
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Get.to(() => const PaymentMethodsScreen()),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorder : AppTheme.border,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isDark
                          ? const Color(0xFF1E284A)
                          : const Color(0xFFEEF2FF),
                      child: const Icon(
                        Icons.credit_card_rounded,
                        color: AppTheme.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        orderController.selectedPayment.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.subtleColor(context),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const _StepHeader(
              number: '03',
              title: 'Order Summary',
              subtitle: 'Review items before placing order',
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppTheme.darkBorder : AppTheme.border,
                ),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Items (${cart.itemCount})',
                    value: cart.subtotal,
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow(
                    label: 'Delivery Fee',
                    value: cart.deliveryFee,
                    free: cart.deliveryFee == 0,
                  ),
                  if (cart.discount > 0) ...[
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: '${cart.appliedCoupon.value} Promo',
                      value: -cart.discount,
                      discount: true,
                    ),
                  ],
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Total Payable',
                    value: cart.total,
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),
            PrimaryButton(
              label:
                  'Confirm & Place Order · \$${cart.total.toStringAsFixed(2)}',
              icon: Icons.check_circle_outline_rounded,
              onPressed: cart.itemCount == 0
                  ? null
                  : () async {
                      final productIds = cart.items.map((e) => e.id).toList();
                      final order = await orderController.placeOrder(
                        cart.total,
                        cart.itemCount,
                        productIds,
                      );
                      cart.clear();
                      Get.off(() => OrderSuccessScreen(order: order));
                    },
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Demo Checkout · No real bank account will be charged.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11.5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF3B50DF),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: AppTheme.subtleColor(context),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.free = false,
    this.discount = false,
  });

  final String label;
  final double value;
  final bool bold;
  final bool free;
  final bool discount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: discount
                ? AppTheme.emerald
                : bold
                    ? AppTheme.textColor(context)
                    : AppTheme.subtleColor(context),
            fontWeight: bold || discount ? FontWeight.w700 : null,
            fontSize: bold ? 15 : 13.5,
          ),
        ),
        Text(
          free
              ? 'FREE'
              : '${discount ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: discount
                ? AppTheme.emerald
                : free
                    ? AppTheme.emerald
                    : AppTheme.textColor(context),
            fontWeight:
                bold || discount || free ? FontWeight.w800 : FontWeight.w600,
            fontSize: bold ? 18 : 14,
          ),
        ),
      ],
    );
  }
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF0F3926)
                      : const Color(0xFFEAF8F0),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 64,
                  color: AppTheme.emerald,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'Order Confirmed!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your demo order has been placed successfully and saved to your device.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.muted,
                  height: 1.5,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorder : AppTheme.border,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'ORDER #${order.id}',
                      style: const TextStyle(
                        color: AppTheme.muted,
                        letterSpacing: 1.2,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}  ·  ${order.itemCount} items',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: 'Track Order',
                onPressed: () => Get.to(() => OrderTrackingScreen(order: order)),
                icon: Icons.local_shipping_outlined,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.offAll(() => const ShopShell()),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    color: AppTheme.blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
