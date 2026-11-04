import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../models/product.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';
import '../cart/cart_screen.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key, required this.title});

  final String title;

  void _showSortOptions(BuildContext context, ProductController controller) {
    const options = [
      'Featured',
      'Price: low to high',
      'Price: high to low',
      'Top rated',
      'Biggest discount',
    ];
    final isDark = AppTheme.isDark(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sort Products',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              ...options.map((option) => Obx(() {
                    final selected = controller.sortBy.value == option;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        option,
                        style: TextStyle(
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected
                              ? AppTheme.blue
                              : AppTheme.textColor(context),
                        ),
                      ),
                      trailing: selected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppTheme.blue)
                          : Icon(Icons.circle_outlined,
                              color: AppTheme.subtleColor(context)),
                      onTap: () {
                        controller.setSort(option);
                        Navigator.of(context).pop();
                      },
                    );
                  })),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final cart = Get.find<CartController>();
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const SearchScreen()),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: Obx(
              () => Badge(
                label: Text('${cart.itemCount}'),
                isLabelVisible: cart.itemCount > 0,
                backgroundColor: AppTheme.blue,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              itemCount: controller.categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() {
                  final selected = category == controller.selectedCategory.value;
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) => controller.selectCategory(category),
                    selectedColor: AppTheme.blue,
                    backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
                    side: BorderSide(
                      color: selected
                          ? AppTheme.blue
                          : (isDark ? AppTheme.darkBorder : AppTheme.border),
                    ),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppTheme.textColor(context),
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    showCheckmark: false,
                  );
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      '${controller.filteredProducts.length} items found',
                      style: TextStyle(
                        color: AppTheme.subtleColor(context),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => TextButton.icon(
                    onPressed: () => _showSortOptions(context, controller),
                    icon: const Icon(Icons.swap_vert_rounded, size: 18),
                    label: Text(controller.sortBy.value),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textColor(context),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final products = controller.filteredProducts;
              if (products.isEmpty) {
                return EmptyState(
                  title: 'No products found',
                  message: 'Try clearing your filters or choosing another category.',
                  buttonLabel: 'Reset filters',
                  onButtonTap: controller.resetFilters,
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 22),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.60,
                ),
                itemBuilder: (context, index) =>
                    ProductCard(product: products[index]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _selectedColor;
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedColor =
        widget.product.colors.isNotEmpty ? widget.product.colors.first : '#1E293B';
    _selectedSize =
        widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'Standard';
  }

  Color _parseHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  void _showWriteReviewModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final commentCtrl = TextEditingController();
    double currentRating = 5.0;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              22,
              18,
              22,
              MediaQuery.of(context).viewInsets.bottom + 22,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Write a Review',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Share your experience with other shoppers.',
                  style: TextStyle(color: AppTheme.muted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                // Star selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return IconButton(
                      icon: Icon(
                        starIndex <= currentRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppTheme.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setModalState(() => currentRating = starIndex.toDouble());
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'What did you think of the product?',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  label: 'Submit Review',
                  onPressed: () {
                    if (commentCtrl.text.trim().isEmpty) {
                      Get.snackbar(
                        'Feedback Needed',
                        'Please write a few words about your experience.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    Get.find<ProductController>().addReview(
                      widget.product.id,
                      nameCtrl.text.trim(),
                      currentRating,
                      commentCtrl.text.trim(),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share Product',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEEF2FF),
                  child: Icon(Icons.link_rounded, color: AppTheme.blue),
                ),
                title: const Text('Copy link to clipboard'),
                subtitle: Text('https://shopease.app/product/${widget.product.id}'),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.snackbar(
                    'Link Copied!',
                    'Product link copied to clipboard.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFEE2E2),
                  child: Icon(Icons.share_outlined, color: AppTheme.rose),
                ),
                title: const Text('Share with friends'),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.snackbar(
                    'Share Opened',
                    'Shared ${widget.product.name} with contacts.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final wishlist = Get.find<WishlistController>();
    final productCtrl = Get.find<ProductController>();
    final isDark = AppTheme.isDark(context);

    // Get live product with newly added reviews
    return Obx(() {
      final liveProduct = productCtrl.products.firstWhere(
        (p) => p.id == widget.product.id,
        orElse: () => widget.product,
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            IconButton(
              onPressed: () => _showShareSheet(context),
              icon: const Icon(Icons.share_outlined),
            ),
            IconButton(
              onPressed: () => wishlist.toggle(liveProduct),
              icon: Icon(
                wishlist.contains(liveProduct.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: wishlist.contains(liveProduct.id)
                    ? AppTheme.rose
                    : AppTheme.textColor(context),
              ),
            ),
            IconButton(
              onPressed: () => Get.to(() => const CartScreen()),
              icon: Badge(
                isLabelVisible: cart.itemCount > 0,
                label: Text('${cart.itemCount}'),
                backgroundColor: AppTheme.blue,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            // Hero Image
            Stack(
              children: [
                ProductImage(
                  product: liveProduct,
                  height: 330,
                  width: double.infinity,
                ),
                if (liveProduct.discountPercent > 0)
                  Positioned(
                    top: 14,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${liveProduct.discountPercent}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Stock Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E284A)
                              : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          liveProduct.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.blue,
                            fontSize: 10,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: liveProduct.stockCount > 0
                                  ? AppTheme.emerald
                                  : AppTheme.rose,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            liveProduct.stockCount > 0
                                ? 'In Stock (${liveProduct.stockCount} left)'
                                : 'Out of Stock',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: liveProduct.stockCount > 0
                                  ? AppTheme.emerald
                                  : AppTheme.rose,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Product Name
                  Text(
                    liveProduct.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                  ),
                  const SizedBox(height: 10),

                  // Rating Row
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppTheme.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${liveProduct.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '·  ${liveProduct.reviews.length + 18} Verified Reviews',
                        style: TextStyle(
                          color: AppTheme.subtleColor(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pricing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${liveProduct.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (liveProduct.oldPrice > liveProduct.price) ...[
                        Text(
                          '\$${liveProduct.oldPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Save \$${liveProduct.savings.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Color Variants
                  if (liveProduct.colors.isNotEmpty) ...[
                    const Text(
                      'COLOR SELECTION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.muted,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: liveProduct.colors.map((hex) {
                        final isSelected = _selectedColor == hex;
                        final color = _parseHex(hex);
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = hex),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppTheme.blue : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: color,
                              child: isSelected
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 15,
                                      color: color.computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Size / Spec Variants
                  if (liveProduct.sizes.isNotEmpty) ...[
                    const Text(
                      'OPTION / SIZE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.muted,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: liveProduct.sizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedSize = size),
                          selectedColor: AppTheme.blue,
                          backgroundColor:
                              isDark ? AppTheme.darkCard : Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.blue
                                : (isDark
                                    ? AppTheme.darkBorder
                                    : AppTheme.border),
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textColor(context),
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 3-Pillar Confidence Reassurance
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppTheme.darkBorder : AppTheme.border,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ReassurancePillar(
                          icon: Icons.local_shipping_outlined,
                          title: 'Free Shipping',
                          subtitle: 'Over \$75',
                        ),
                        _ReassurancePillar(
                          icon: Icons.verified_user_outlined,
                          title: '100% Genuine',
                          subtitle: 'Quality checked',
                        ),
                        _ReassurancePillar(
                          icon: Icons.restart_alt_rounded,
                          title: '30-Day Returns',
                          subtitle: 'Easy refunds',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Description
                  const Text(
                    'About this Product',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    liveProduct.description,
                    style: TextStyle(
                      color: AppTheme.subtleColor(context),
                      height: 1.55,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 26),

                  // Customer Reviews Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Reviews (${liveProduct.reviews.length})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showWriteReviewModal(context),
                        icon: const Icon(Icons.rate_review_outlined, size: 16),
                        label: const Text('Add Review'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Reviews List
                  if (liveProduct.reviews.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppTheme.darkBorder : AppTheme.border,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'No user reviews yet. Be the first to share your thoughts!',
                          style: TextStyle(color: AppTheme.muted, fontSize: 12.5),
                        ),
                      ),
                    )
                  else
                    ...liveProduct.reviews.map(
                      (r) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppTheme.darkBorder : AppTheme.border,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFFEEF2FF),
                                  child: Text(
                                    r.author.isNotEmpty
                                        ? r.author[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: AppTheme.blue,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.author,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ...List.generate(
                                            5,
                                            (s) => Icon(
                                              s < r.rating
                                                  ? Icons.star_rounded
                                                  : Icons.star_outline_rounded,
                                              color: AppTheme.amber,
                                              size: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            r.date,
                                            style: const TextStyle(
                                              fontSize: 10.5,
                                              color: AppTheme.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              r.comment,
                              style: TextStyle(
                                color: AppTheme.subtleColor(context),
                                fontSize: 12.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 25),
                  PrimaryButton(
                    label:
                        'Add to Bag  ·  \$${liveProduct.price.toStringAsFixed(2)}',
                    onPressed: () {
                      cart.add(
                        liveProduct,
                        color: _selectedColor,
                        size: _selectedSize,
                      );
                    },
                    icon: Icons.shopping_bag_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ReassurancePillar extends StatelessWidget {
  const _ReassurancePillar({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.blue, size: 21),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: AppTheme.muted, fontSize: 9.5),
        ),
      ],
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _products = Get.find<ProductController>();

  @override
  void dispose() {
    _products.search('');
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch(String term) {
    _searchController.text = term;
    _products.search(term);
    _products.addRecentSearch(term);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _products.search,
          onSubmitted: (val) => _products.addRecentSearch(val),
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: false,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _products.search('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: Obx(() {
        final results = _products.filteredProducts;

        if (_searchController.text.isEmpty) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Trending Searches
              const Text(
                'TRENDING DISCOVERIES',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Headphones',
                  'Sneakers',
                  'Face Serum',
                  'Ceramic Lamp',
                  'Water Bottle',
                  'Digital Camera',
                ].map((tag) {
                  return ActionChip(
                    label: Text(tag),
                    avatar: const Icon(Icons.trending_up_rounded, size: 15),
                    backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
                    side: BorderSide(
                      color: isDark ? AppTheme.darkBorder : AppTheme.border,
                    ),
                    onPressed: () => _triggerSearch(tag),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              // Recent Searches
              if (_products.recentSearches.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RECENT SEARCHES',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    TextButton(
                      onPressed: _products.clearRecentSearches,
                      child: const Text('Clear all', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ..._products.recentSearches.map(
                  (search) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.history_rounded, size: 19),
                    title: Text(search, style: const TextStyle(fontSize: 13.5)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16),
                      onPressed: () => _products.removeRecentSearch(search),
                    ),
                    onTap: () => _triggerSearch(search),
                  ),
                ),
              ],
            ],
          );
        }

        if (results.isEmpty) {
          return const EmptyState(
            title: 'No matches found',
            message: 'Try checking your spelling or use different keywords.',
            icon: Icons.search_off_rounded,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 4),
              child: Text(
                '${results.length} results for "${_searchController.text}"',
                style: TextStyle(
                  color: AppTheme.subtleColor(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.60,
                ),
                itemBuilder: (context, index) =>
                    ProductCard(product: results[index]),
              ),
            ),
          ],
        );
      }),
    );
  }
}
