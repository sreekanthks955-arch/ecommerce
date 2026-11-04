import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Row(
            children: [
              const Text('Saved Items'),
              if (wishlist.items.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${wishlist.items.length}',
                    style: const TextStyle(
                      color: AppTheme.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          Obx(() {
            if (wishlist.items.isEmpty) return const SizedBox.shrink();
            return TextButton.icon(
              onPressed: wishlist.addAllToCart,
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 17),
              label: const Text(
                'Add All',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (wishlist.items.isEmpty) {
          return EmptyState(
            title: 'Your wishlist is empty',
            message:
                'Tap the heart icon on any product to save it for later and track deals.',
            icon: Icons.favorite_border_rounded,
            buttonLabel: 'Explore Products',
            onButtonTap: () {
              Get.find<NavigationController>().select(0);
              Get.back();
            },
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          itemCount: wishlist.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            childAspectRatio: 0.60,
          ),
          itemBuilder: (context, index) =>
              ProductCard(product: wishlist.items[index]),
        );
      }),
    );
  }
}
