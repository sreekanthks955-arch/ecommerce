import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_controllers.dart';
import '../models/product.dart';
import '../pages/products/product_screens.dart';
import '../services/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    if (isSecondary) {
      return SizedBox(
        height: 52,
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon == null
              ? const SizedBox.shrink()
              : Icon(icon, size: 19, color: AppTheme.blue),
          label: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppTheme.blue,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.blue, width: 1.4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      );
    }

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(icon, size: 19, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF4F5FF7) : AppTheme.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppTheme.blue.withValues(alpha: 0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.height = 150,
    this.width,
    this.fit = BoxFit.cover,
  });

  final Product product;
  final double height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Image.network(
      product.imageUrl,
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: height,
          width: width ?? double.infinity,
          color: isDark ? const Color(0xFF192233) : const Color(0xFFF1F4F9),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        height: height,
        width: width ?? double.infinity,
        color: isDark ? const Color(0xFF192233) : const Color(0xFFF1F4F9),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.muted,
          size: 32,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.compact = false,
  });

  final Product product;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();
    final cart = Get.find<CartController>();
    final isDark = AppTheme.isDark(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : const Color(0xFFEEF0F5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : const Color(0x0A0F172A),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProductImage(
                  product: product,
                  height: compact ? 108 : 138,
                ),
                // Discount pill
                if (product.discountPercent > 0)
                  Positioned(
                    top: 9,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E284A).withValues(alpha: 0.95)
                            : Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '-${product.discountPercent}%',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF7585FF) : AppTheme.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                // Stock urgency badge
                if (product.stockCount <= 5)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.rose.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt, color: Colors.white, size: 11),
                          const SizedBox(width: 2),
                          Text(
                            'Only ${product.stockCount} left',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Favorite heart
                Positioned(
                  top: 5,
                  right: 5,
                  child: Obx(() {
                    final isFav = wishlist.contains(product.id);
                    return Material(
                      color: isDark
                          ? const Color(0xFF1E2638).withValues(alpha: 0.85)
                          : Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => wishlist.toggle(product),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav
                                ? AppTheme.rose
                                : AppTheme.subtleColor(context),
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                11,
                compact ? 8 : 10,
                11,
                compact ? 9 : 11,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.subtleColor(context),
                      fontSize: compact ? 9 : 9.5,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    maxLines: compact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 12.5 : 13,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: AppTheme.textColor(context),
                    ),
                  ),
                  SizedBox(height: compact ? 4 : 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppTheme.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textColor(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviews.length + 18})',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.subtleColor(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 6 : 8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: compact ? 13.5 : 14.5,
                          color: AppTheme.textColor(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (product.oldPrice > product.price)
                        Text(
                          '\$${product.oldPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      Material(
                        color: isDark ? const Color(0xFF4F5FF7) : AppTheme.blue,
                        shape: const CircleBorder(),
                        elevation: 1,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => cart.add(product),
                          child: Padding(
                            padding: EdgeInsets.all(compact ? 5.5 : 6.5),
                            child: Icon(
                              Icons.add_rounded,
                              size: compact ? 16 : 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(50, 32),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel!,
                  style: const TextStyle(
                    color: AppTheme.blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 11, color: AppTheme.blue),
              ],
            ),
          ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.shopping_bag_outlined,
    this.buttonLabel,
    this.onButtonTap,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor:
                  isDark ? const Color(0xFF1E283E) : const Color(0xFFEEF2FF),
              child: Icon(icon, size: 36, color: AppTheme.blue),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.subtleColor(context),
                height: 1.5,
                fontSize: 13,
              ),
            ),
            if (buttonLabel != null && onButtonTap != null) ...[
              const SizedBox(height: 20),
              PrimaryButton(
                label: buttonLabel!,
                onPressed: onButtonTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FreeShippingBar extends StatelessWidget {
  const FreeShippingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final isDark = AppTheme.isDark(context);

    return Obx(() {
      final remaining = cart.remainingForFreeShipping;
      final progress = cart.freeShippingProgress;
      final unlocked = remaining == 0;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: unlocked
              ? (isDark ? const Color(0xFF0F3926) : const Color(0xFFEBFBF2))
              : (isDark ? const Color(0xFF1E283E) : const Color(0xFFEEF2FF)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unlocked
                ? AppTheme.emerald.withValues(alpha: 0.3)
                : AppTheme.blue.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  unlocked
                      ? Icons.verified_rounded
                      : Icons.local_shipping_outlined,
                  size: 18,
                  color: unlocked ? AppTheme.emerald : AppTheme.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    unlocked
                        ? 'Congratulations! You unlocked FREE Delivery! 🎉'
                        : 'Add \$${remaining.toStringAsFixed(2)} more for FREE Delivery',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: unlocked
                          ? (isDark
                              ? const Color(0xFF34D399)
                              : const Color(0xFF065F46))
                          : (isDark
                              ? const Color(0xFF93C5FD)
                              : const Color(0xFF1E40AF)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  unlocked ? AppTheme.emerald : AppTheme.blue,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FlashDealTimer extends StatefulWidget {
  const FlashDealTimer({super.key});

  @override
  State<FlashDealTimer> createState() => _FlashDealTimerState();
}

class _FlashDealTimerState extends State<FlashDealTimer> {
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 5, minutes: 42, seconds: 18);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft = _timeLeft - const Duration(seconds: 1);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _timeLeft.inHours.toString().padLeft(2, '0');
    final minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');

    Widget block(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        block(hours),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        block(minutes),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        block(seconds),
      ],
    );
  }
}
