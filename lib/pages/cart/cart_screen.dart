import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../models/product.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text('My Bag (${cart.itemCount})'),
        ),
        actions: [
          Obx(() {
            if (cart.items.isEmpty) return const SizedBox.shrink();
            return TextButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Clear Bag',
                  middleText: 'Are you sure you want to remove all items from your bag?',
                  textConfirm: 'Clear',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  buttonColor: AppTheme.rose,
                  onConfirm: () {
                    cart.clear();
                    Get.back();
                  },
                );
              },
              child: const Text('Clear', style: TextStyle(color: AppTheme.rose)),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (cart.items.isEmpty) {
          return EmptyState(
            title: 'Your bag is empty',
            message:
                'Explore our latest arrivals and timeless essentials to fill your bag.',
            icon: Icons.shopping_bag_outlined,
            buttonLabel: 'Start Shopping',
            onButtonTap: () {
              Get.find<NavigationController>().select(0);
            },
          );
        }

        return Column(
          children: [
            // Free Shipping Progress
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 8, 18, 6),
              child: FreeShippingBar(),
            ),

            // Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                itemCount: cart.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    CartItemTile(product: cart.items[index]),
              ),
            ),

            // Checkout Footer
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor(context),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppTheme.darkBorder : const Color(0xFFEFF1F6),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : const Color(0x0C0E1A36),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _CouponSection(cart: cart),
                  const SizedBox(height: 14),
                  _PriceLine(label: 'Subtotal', value: cart.subtotal),
                  const SizedBox(height: 8),
                  _PriceLine(
                    label: 'Estimated Delivery',
                    value: cart.deliveryFee,
                    isFree: cart.deliveryFee == 0,
                  ),
                  if (cart.discount > 0) ...[
                    const SizedBox(height: 8),
                    _PriceLine(
                      label: '${cart.appliedCoupon.value} Discount',
                      value: -cart.discount,
                      isDiscount: true,
                    ),
                  ],
                  const Divider(height: 22),
                  _PriceLine(label: 'Total Amount', value: cart.total, bold: true),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Proceed to Checkout  ·  \$${cart.total.toStringAsFixed(2)}',
                    onPressed: () => Get.to(() => const CheckoutScreen()),
                    icon: Icons.lock_outline_rounded,
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_outlined, size: 12, color: AppTheme.muted),
                      SizedBox(width: 4),
                      Text(
                        'Secure 256-Bit SSL Checkout · Demo Mode',
                        style: TextStyle(color: AppTheme.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CouponSection extends StatefulWidget {
  const _CouponSection({required this.cart});

  final CartController cart;

  @override
  State<_CouponSection> createState() => _CouponSectionState();
}

class _CouponSectionState extends State<_CouponSection> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Obx(() {
      if (widget.cart.appliedCoupon.value.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F3926) : const Color(0xFFEEF8F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.emerald.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_offer_rounded,
                color: AppTheme.emerald,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.cart.appliedCoupon.value} Applied · Saved \$${widget.cart.discount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF1B6B40),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.cart.removeCoupon();
                  _codeController.clear();
                },
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Remove', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Enter Promo Code',
                      prefixIcon: Icon(Icons.local_offer_outlined, size: 18),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () =>
                      widget.cart.applyCoupon(_codeController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Quick promo suggestions
          Row(
            children: [
              const Text(
                'Try: ',
                style: TextStyle(fontSize: 11, color: AppTheme.muted),
              ),
              _QuickPromoTag(
                code: 'SAVE10',
                label: '10% OFF',
                onTap: () {
                  _codeController.text = 'SAVE10';
                  widget.cart.applyCoupon('SAVE10');
                },
              ),
              const SizedBox(width: 6),
              _QuickPromoTag(
                code: 'WELCOME5',
                label: '\$5 OFF',
                onTap: () {
                  _codeController.text = 'WELCOME5';
                  widget.cart.applyCoupon('WELCOME5');
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _QuickPromoTag extends StatelessWidget {
  const _QuickPromoTag({
    required this.code,
    required this.label,
    required this.onTap,
  });

  final String code;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
        decoration: BoxDecoration(
          color: AppTheme.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '$code ($label)',
          style: const TextStyle(
            color: AppTheme.blue,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final isDark = AppTheme.isDark(context);

    final selectedColor = cart.selectedColors[product.id];
    final selectedSize = cart.selectedSizes[product.id];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ProductImage(
              product: product,
              height: 94,
              width: 94,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    height: 1.25,
                  ),
                ),
                if (selectedSize != null || selectedColor != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (selectedSize != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E283E)
                                : const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            selectedSize,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.blue,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppTheme.blue,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // Save for later
                    IconButton(
                      icon: const Icon(Icons.favorite_border_rounded, size: 19),
                      color: AppTheme.muted,
                      onPressed: () => cart.moveToWishlist(product),
                      tooltip: 'Save for later',
                      visualDensity: VisualDensity.compact,
                    ),
                    // Trash
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 19),
                      color: AppTheme.muted,
                      onPressed: () => cart.remove(product),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Quantity Stepper
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove_rounded,
                      onTap: () => cart.decrease(product),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(
                        () => Text(
                          '${cart.quantityFor(product.id)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      onTap: () => cart.add(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E283E) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : const Color(0xFFE2E8F0),
          ),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.value,
    this.bold = false,
    this.isFree = false,
    this.isDiscount = false,
  });

  final String label;
  final double value;
  final bool bold;
  final bool isFree;
  final bool isDiscount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDiscount
                ? AppTheme.emerald
                : bold
                    ? AppTheme.textColor(context)
                    : AppTheme.subtleColor(context),
            fontWeight:
                bold || isDiscount ? FontWeight.w700 : FontWeight.normal,
            fontSize: bold ? 15 : 13.5,
          ),
        ),
        Text(
          isFree
              ? 'FREE'
              : '${isDiscount ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: isDiscount
                ? AppTheme.emerald
                : isFree
                    ? AppTheme.emerald
                    : AppTheme.textColor(context),
            fontWeight:
                bold || isDiscount || isFree ? FontWeight.w800 : FontWeight.w600,
            fontSize: bold ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
