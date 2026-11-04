import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../models/order_model.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return EmptyState(
            title: 'No orders yet',
            message:
                'Your placed orders will show up here along with live tracking and reordering.',
            icon: Icons.receipt_long_outlined,
            buttonLabel: 'Start Shopping',
            onButtonTap: () {
              Get.find<NavigationController>().select(0);
              Get.back();
            },
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: controller.orders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) =>
              _OrderCard(order: controller.orders[index]),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final isDark = AppTheme.isDark(context);

    return InkWell(
      onTap: () => Get.to(() => OrderTrackingScreen(order: order)),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.border,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isDark
                      ? const Color(0xFF1E284A)
                      : const Color(0xFFEEF2FF),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppTheme.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${order.date}  ·  ${order.itemCount} items',
                        style: TextStyle(
                          color: AppTheme.subtleColor(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.status,
                        style: const TextStyle(
                          color: AppTheme.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => orderController.reorder(order),
                  icon: const Icon(Icons.replay_rounded, size: 16),
                  label: const Text('Reorder items'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      Get.to(() => OrderTrackingScreen(order: order)),
                  icon: const Icon(Icons.local_shipping_outlined, size: 16),
                  label: const Text('Track Package'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    const steps = [
      (
        'Order Placed & Verified',
        'Your demo order has been received and confirmed.',
        Icons.check_circle_rounded,
        true
      ),
      (
        'Preparing at Warehouse',
        'Items picked and packed with care.',
        Icons.inventory_2_outlined,
        true
      ),
      (
        'Dispatched & On the Way',
        'Courier is en route with express tracking.',
        Icons.local_shipping_outlined,
        false
      ),
      (
        'Delivered to Address',
        'Package delivered to your front door.',
        Icons.home_outlined,
        false
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        children: [
          // Order Card Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E284A) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SHIPMENT STATUS',
                  style: TextStyle(
                    color: AppTheme.blue,
                    letterSpacing: 1.2,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '#${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Placed on ${order.date}  ·  Total: \$${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppTheme.subtleColor(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Timeline Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 18),

          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final completed = step.$4;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 38,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: completed
                            ? AppTheme.blue
                            : (isDark
                                ? const Color(0xFF1E283E)
                                : const Color(0xFFF1F5F9)),
                        child: Icon(
                          step.$3,
                          size: 16,
                          color: completed ? Colors.white : AppTheme.muted,
                        ),
                      ),
                      if (index < steps.length - 1)
                        Container(
                          width: 2,
                          height: 48,
                          color: completed
                              ? AppTheme.blue
                              : (isDark
                                  ? AppTheme.darkBorder
                                  : const Color(0xFFE2E8F0)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$1,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: completed
                                ? AppTheme.textColor(context)
                                : AppTheme.subtleColor(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.$2,
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Share Tracking Receipt',
            onPressed: () {
              Get.snackbar(
                'Receipt Shared',
                'Tracking link for #${order.id} copied to clipboard.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: Icons.share_outlined,
            isSecondary: true,
          ),
        ],
      ),
    );
  }
}
