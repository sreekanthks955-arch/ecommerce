import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';
import '../models/product.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool isOrder;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.icon = Icons.notifications_outlined,
    this.isOrder = false,
    this.isRead = false,
  });
}

class NotificationController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[
    NotificationItem(
      id: 'n1',
      title: 'Order Confirmed',
      message: 'Your order #SE9284 has been received and is being prepared.',
      time: '15m ago',
      icon: Icons.check_circle_outline,
      isOrder: true,
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Flash Sale Alert! ⚡',
      message: 'Extra 10% off with promo code SAVE10 today only.',
      time: '2h ago',
      icon: Icons.local_offer_outlined,
      isOrder: false,
      isRead: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'New Arrivals Dropped',
      message: 'Check out the new Studio Audio & Fashion collection.',
      time: '1d ago',
      icon: Icons.auto_awesome_outlined,
      isOrder: false,
      isRead: true,
    ),
  ].obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }

  void markAllAsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void addNotification({
    required String title,
    required String message,
    bool isOrder = false,
  }) {
    notifications.insert(
      0,
      NotificationItem(
        id: 'n_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        time: 'Just now',
        icon: isOrder
            ? Icons.local_shipping_outlined
            : Icons.notifications_active_outlined,
        isOrder: isOrder,
        isRead: false,
      ),
    );
  }
}

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[
    const Product(
      id: 'p1',
      name: 'Studio Wireless Headphones',
      category: 'Electronics',
      price: 79.99,
      oldPrice: 119.99,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=700',
      description:
          'Rich, balanced sound with active noise reduction and plush memory-foam earcups for all-day listening.',
      colors: ['#0F172A', '#E2E8F0', '#3B82F6'],
      sizes: ['Standard Fit', 'Pro Comfort'],
      stockCount: 4,
      isFeatured: true,
      reviews: [
        ProductReview(
          id: 'r1',
          author: 'Sarah M.',
          rating: 5.0,
          comment:
              'Phenomenal battery life and crystal clear acoustics. Best headphones I have owned!',
          date: '2 days ago',
        ),
        ProductReview(
          id: 'r2',
          author: 'Liam T.',
          rating: 4.5,
          comment: 'Very comfortable for flights and office calls. Seamless Bluetooth pairing.',
          date: '1 week ago',
        ),
      ],
    ),
    const Product(
      id: 'p2',
      name: 'Everyday Leather Sneakers',
      category: 'Fashion',
      price: 64.50,
      oldPrice: 89.00,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=700',
      description:
          'Handcrafted supple leather silhouette with ergonomic arch support and timeless street aesthetic.',
      colors: ['#DC2626', '#0F172A', '#FFFFFF'],
      sizes: ['US 8', 'US 9', 'US 10', 'US 11'],
      stockCount: 6,
      isFeatured: true,
      reviews: [
        ProductReview(
          id: 'r3',
          author: 'Marcus B.',
          rating: 5.0,
          comment: 'Incredibly sleek and durable. Got so many compliments already.',
          date: '3 days ago',
        ),
      ],
    ),
    const Product(
      id: 'p3',
      name: 'Minimal Ceramic Table Lamp',
      category: 'Home',
      price: 42.00,
      oldPrice: 56.00,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=700',
      description:
          'Bring a calming warm ambient glow to your nightstand or reading nook. Textured matte porcelain finish.',
      colors: ['#E2E8F0', '#78350F', '#1E293B'],
      sizes: ['Compact', 'Accent Large'],
      stockCount: 8,
      isFeatured: false,
      reviews: [
        ProductReview(
          id: 'r4',
          author: 'Elena R.',
          rating: 4.5,
          comment: 'Warm, soft light that creates the coziest evening vibe in my living room.',
          date: '5 days ago',
        ),
      ],
    ),
    const Product(
      id: 'p4',
      name: 'Classic Canvas Backpack',
      category: 'Fashion',
      price: 49.99,
      oldPrice: 69.99,
      rating: 4.5,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=700',
      description:
          'Weather-resistant dual canvas with padded 16-inch laptop pocket and quick-access magnetic flap.',
      colors: ['#1E293B', '#D97706', '#065F46'],
      sizes: ['18L Regular', '24L Explorer'],
      stockCount: 11,
      isFeatured: false,
    ),
    const Product(
      id: 'p5',
      name: 'Hydrating Daily Skincare Set',
      category: 'Beauty',
      price: 34.00,
      oldPrice: 45.00,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=700',
      description:
          'Dermatologist tested 3-step ritual with hyaluronic serum, gentle botanical cleanser and peptide cream.',
      colors: ['#EC4899', '#8B5CF6'],
      sizes: ['Travel Kit', 'Full 3-Piece Set'],
      stockCount: 3,
      isFeatured: true,
      reviews: [
        ProductReview(
          id: 'r5',
          author: 'Sophia K.',
          rating: 5.0,
          comment: 'Noticeable difference in skin texture in just 4 days. Absolutely in love!',
          date: 'Yesterday',
        ),
      ],
    ),
    const Product(
      id: 'p6',
      name: 'Smart Fitness Watch',
      category: 'Electronics',
      price: 99.00,
      oldPrice: 139.00,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=700',
      description:
          'All-day heart monitor, SPO2 sensor, AMOLED crystal display and 7-day battery life on a single charge.',
      colors: ['#0F172A', '#D1D5DB', '#BE185D'],
      sizes: ['40mm Slim', '44mm Pro'],
      stockCount: 5,
      isFeatured: true,
    ),
    const Product(
      id: 'p7',
      name: 'Soft Knit Throw Blanket',
      category: 'Home',
      price: 38.00,
      oldPrice: 52.00,
      rating: 4.4,
      imageUrl:
          'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=700',
      description:
          'Plush ribbed chenille knit providing lightweight warmth for chilly evenings on the couch.',
      colors: ['#F3F4F6', '#D97706', '#374151'],
      sizes: ['50x60 in', '60x80 in'],
      stockCount: 9,
      isFeatured: false,
    ),
    const Product(
      id: 'p8',
      name: 'Everyday Crossbody Bag',
      category: 'Fashion',
      price: 55.00,
      oldPrice: 75.00,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=700',
      description:
          'Hands-free utility with structured vegan leather, brass hardware and adjustable woven strap.',
      colors: ['#78350F', '#0F172A', '#10B981'],
      sizes: ['Medium', 'Large'],
      stockCount: 14,
      isFeatured: false,
    ),
    const Product(
      id: 'p9',
      name: 'Portable Bluetooth Speaker',
      category: 'Electronics',
      price: 45.99,
      oldPrice: 64.99,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=700',
      description:
          'IPX7 waterproof 360-degree bass with 14-hour playtime and wireless stereo pairing.',
      colors: ['#1E293B', '#2563EB', '#DC2626'],
      sizes: ['Mini 10W', 'Boom 25W'],
      stockCount: 8,
      isFeatured: false,
    ),
    const Product(
      id: 'p10',
      name: 'Noise Cancelling Earbuds',
      category: 'Electronics',
      price: 59.00,
      oldPrice: 84.00,
      rating: 4.5,
      imageUrl:
          'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=700',
      description:
          'True wireless earbuds with transparency mode, quad mic calling and sleek wireless charging case.',
      colors: ['#FFFFFF', '#0F172A'],
      sizes: ['Standard In-Ear'],
      stockCount: 10,
      isFeatured: false,
    ),
    const Product(
      id: 'p11',
      name: 'Polarized Everyday Sunglasses',
      category: 'Fashion',
      price: 29.99,
      oldPrice: 42.00,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=700',
      description:
          'Ultra-light acetate frames with UV400 polarized optics ensuring clear, glare-free vision.',
      colors: ['#0F172A', '#78350F', '#059669'],
      sizes: ['Classic Fit'],
      stockCount: 16,
      isFeatured: false,
    ),
    const Product(
      id: 'p12',
      name: 'Relaxed Cotton T-shirt',
      category: 'Fashion',
      price: 24.00,
      oldPrice: 32.00,
      rating: 4.4,
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=700',
      description:
          'Heavyweight 220 GSM organic combed cotton that drapes effortlessly and softens with every wash.',
      colors: ['#FFFFFF', '#1F2937', '#9CA3AF', '#3B82F6'],
      sizes: ['S', 'M', 'L', 'XL'],
      stockCount: 22,
      isFeatured: false,
    ),
    const Product(
      id: 'p13',
      name: 'Stainless Steel Water Bottle',
      category: 'Home',
      price: 22.50,
      oldPrice: 30.00,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=700',
      description:
          'Double-wall vacuum insulated flask keeping drinks cold for 24 hours or piping hot for 12 hours.',
      colors: ['#374151', '#065F46', '#1E40AF'],
      sizes: ['24 oz', '32 oz'],
      stockCount: 12,
      isFeatured: false,
    ),
    const Product(
      id: 'p14',
      name: 'Modern Ceramic Coffee Set',
      category: 'Home',
      price: 31.00,
      oldPrice: 44.00,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=700',
      description:
          'Set of 2 artisan stoneware mugs with speckled glaze and matching minimalist saucers.',
      colors: ['#D1D5DB', '#78350F'],
      sizes: ['12 oz Set'],
      stockCount: 7,
      isFeatured: false,
    ),
    const Product(
      id: 'p15',
      name: 'Everyday Cushion Cover Set',
      category: 'Home',
      price: 27.00,
      oldPrice: 36.00,
      rating: 4.3,
      imageUrl:
          'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=700',
      description:
          'Pair of heavyweight woven linen-cotton cushion covers with hidden zipper closure.',
      colors: ['#F3F4F6', '#9CA3AF', '#D97706'],
      sizes: ['18x18 in', '20x20 in'],
      stockCount: 15,
      isFeatured: false,
    ),
    const Product(
      id: 'p16',
      name: 'Daily Glow Face Serum',
      category: 'Beauty',
      price: 28.00,
      oldPrice: 39.00,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?w=700',
      description:
          'Concentrated Vitamin C and Niacinamide formula to fade dark spots and boost natural radiance.',
      colors: ['#F59E0B'],
      sizes: ['30ml Dropper', '50ml Value'],
      stockCount: 18,
      isFeatured: true,
    ),
    const Product(
      id: 'p17',
      name: 'Nourishing Hand Care Duo',
      category: 'Beauty',
      price: 18.50,
      oldPrice: 25.00,
      rating: 4.5,
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=700',
      description:
          'Shea butter hand balm and exfoliating botanical wash scented with cedarwood and bergamot.',
      colors: ['#10B981'],
      sizes: ['Duo Pack (2x 75ml)'],
      stockCount: 14,
      isFeatured: false,
    ),
    const Product(
      id: 'p18',
      name: 'Compact Digital Camera',
      category: 'Electronics',
      price: 119.00,
      oldPrice: 159.00,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=700',
      description:
          'Pocket-sized 4K point-and-shoot camera with optical zoom and instant mobile Wi-Fi transfer.',
      colors: ['#0F172A', '#9CA3AF'],
      sizes: ['Camera Only', 'Starter Kit (+64GB SD)'],
      stockCount: 2,
      isFeatured: true,
    ),
    const Product(
      id: 'p19',
      name: 'Textured Weekend Tote',
      category: 'Fashion',
      price: 39.00,
      oldPrice: 54.00,
      rating: 4.5,
      imageUrl:
          'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=700',
      description:
          'Spacious cotton canvas tote with reinforced vegan leather handles and key clip.',
      colors: ['#F3F4F6', '#1E293B'],
      sizes: ['Overnight 22L'],
      stockCount: 11,
      isFeatured: false,
    ),
    const Product(
      id: 'p20',
      name: 'Soft Cotton Bath Towels',
      category: 'Home',
      price: 33.00,
      oldPrice: 46.00,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1600369671236-e74521d4b6ad?w=700',
      description:
          'Set of 2 ultra-absorbent 650 GSM Turkish combed cotton bath towels with dobby border.',
      colors: ['#FFFFFF', '#93C5FD', '#D1D5DB'],
      sizes: ['Set of 2', 'Set of 4'],
      stockCount: 13,
      isFeatured: false,
    ),
  ].obs;

  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'Featured'.obs;

  // Filter criteria
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 200.0.obs;
  final RxDouble minRating = 0.0.obs;

  // Recent searches
  final RxList<String> recentSearches = <String>[
    'Wireless Headphones',
    'Leather Sneakers',
    'Ceramic Lamp',
    'Face Serum',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final box = Hive.box('products');
    for (final product in products) {
      box.put(product.id, product.toMap());
    }
  }

  List<String> get categories => [
        'All',
        'Electronics',
        'Fashion',
        'Home',
        'Beauty',
      ];

  List<Product> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  List<Product> get flashSaleProducts =>
      products.where((p) => p.discountPercent >= 25).toList();

  List<Product> get filteredProducts {
    final result = products.where((product) {
      final matchesCategory = selectedCategory.value == 'All' ||
          product.category == selectedCategory.value;
      final query = searchQuery.value.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      final matchesPrice =
          product.price >= minPrice.value && product.price <= maxPrice.value;
      final matchesRating = product.rating >= minRating.value;
      return matchesCategory && matchesSearch && matchesPrice && matchesRating;
    }).toList();

    switch (sortBy.value) {
      case 'Price: low to high':
        result.sort((a, b) => a.price.compareTo(b.price));
      case 'Price: high to low':
        result.sort((a, b) => b.price.compareTo(a.price));
      case 'Top rated':
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case 'Biggest discount':
        result.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    }
    return result;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void search(String query) {
    searchQuery.value = query;
  }

  void addRecentSearch(String query) {
    final clean = query.trim();
    if (clean.isNotEmpty && !recentSearches.contains(clean)) {
      recentSearches.insert(0, clean);
      if (recentSearches.length > 8) recentSearches.removeLast();
    }
  }

  void removeRecentSearch(String query) {
    recentSearches.remove(query);
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  void setSort(String value) {
    sortBy.value = value;
  }

  void setPriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  void setMinRating(double rating) {
    minRating.value = rating;
  }

  void resetFilters() {
    minPrice.value = 0.0;
    maxPrice.value = 200.0;
    minRating.value = 0.0;
    sortBy.value = 'Featured';
  }

  void addReview(
      String productId, String author, double rating, String comment) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final p = products[index];
      final newReview = ProductReview(
        id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
        author: author.isEmpty ? 'Verified Buyer' : author,
        rating: rating,
        comment: comment,
        date: 'Just now',
      );
      final updatedReviews = [newReview, ...p.reviews];
      final avgRating = (updatedReviews.fold<double>(0, (sum, r) => sum + r.rating) /
          updatedReviews.length);
      final updatedProduct = p.copyWith(
        reviews: updatedReviews,
        rating: double.parse(avgRating.toStringAsFixed(1)),
      );
      products[index] = updatedProduct;
      final box = Hive.box('products');
      box.put(productId, updatedProduct.toMap());
      products.refresh();
      Get.snackbar(
        'Review Submitted',
        'Thank you for rating $author!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class CartController extends GetxController {
  final Box<int> _box = Hive.box<int>('cart');
  final RxMap<String, int> quantities = <String, int>{}.obs;
  final RxString appliedCoupon = ''.obs;

  // Selected variants per product
  final RxMap<String, String> selectedColors = <String, String>{}.obs;
  final RxMap<String, String> selectedSizes = <String, String>{}.obs;

  static const double freeShippingThreshold = 75.0;

  @override
  void onInit() {
    super.onInit();
    quantities.addAll(
      _box.toMap().map((key, value) => MapEntry(key.toString(), value)),
    );
  }

  List<Product> get items {
    final products = Get.find<ProductController>().products;
    return quantities.keys
        .map((id) => products.firstWhereOrNull((product) => product.id == id))
        .whereType<Product>()
        .toList();
  }

  int quantityFor(String productId) => quantities[productId] ?? 0;
  int get itemCount =>
      quantities.values.fold(0, (sum, quantity) => sum + quantity);
  double get subtotal => items.fold(
        0,
        (sum, product) => sum + product.price * quantityFor(product.id),
      );

  double get remainingForFreeShipping =>
      (freeShippingThreshold - subtotal).clamp(0.0, freeShippingThreshold);

  double get freeShippingProgress =>
      (subtotal / freeShippingThreshold).clamp(0.0, 1.0);

  double get deliveryFee =>
      itemCount == 0 || subtotal >= freeShippingThreshold || appliedCoupon.value == 'FREESHIP'
          ? 0.0
          : 5.99;

  double get discount {
    if (appliedCoupon.value == 'SAVE10') return subtotal * 0.10;
    if (appliedCoupon.value == 'WELCOME5') return (subtotal > 5.0) ? 5.0 : subtotal;
    return 0.0;
  }

  double get total => (subtotal + deliveryFee - discount).clamp(0.0, double.infinity);

  void selectVariant(String productId, {String? color, String? size}) {
    if (color != null) selectedColors[productId] = color;
    if (size != null) selectedSizes[productId] = size;
  }

  bool applyCoupon(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'SAVE10') {
      appliedCoupon.value = 'SAVE10';
      Get.snackbar(
        'Promo Applied!',
        '10% discount added to your bag.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else if (clean == 'WELCOME5') {
      appliedCoupon.value = 'WELCOME5';
      Get.snackbar(
        'Promo Applied!',
        '\$5.00 discount added to your bag.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else if (clean == 'FREESHIP') {
      appliedCoupon.value = 'FREESHIP';
      Get.snackbar(
        'Promo Applied!',
        'Free shipping applied to your bag.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    }
    Get.snackbar(
      'Invalid Promo Code',
      'Try SAVE10 (10% off) or WELCOME5 (\$5 off).',
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  void removeCoupon() {
    appliedCoupon.value = '';
  }

  void add(Product product, {String? color, String? size, bool showNotification = true}) {
    final nextQuantity = quantityFor(product.id) + 1;
    quantities[product.id] = nextQuantity;
    _box.put(product.id, nextQuantity);
    if (color != null) selectedColors[product.id] = color;
    if (size != null) selectedSizes[product.id] = size;

    if (showNotification) {
      Get.snackbar(
        'Added to Bag',
        product.name,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void decrease(Product product) {
    final nextQuantity = quantityFor(product.id) - 1;
    if (nextQuantity <= 0) {
      remove(product);
      return;
    }
    quantities[product.id] = nextQuantity;
    _box.put(product.id, nextQuantity);
  }

  void remove(Product product) {
    quantities.remove(product.id);
    _box.delete(product.id);
  }

  void moveToWishlist(Product product) {
    remove(product);
    final wishlist = Get.find<WishlistController>();
    if (!wishlist.contains(product.id)) {
      wishlist.toggle(product);
    }
    Get.snackbar(
      'Saved for Later',
      '${product.name} moved to wishlist',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clear() {
    quantities.clear();
    _box.clear();
    removeCoupon();
  }
}

class WishlistController extends GetxController {
  final Box<bool> _box = Hive.box<bool>('wishlist');
  final RxSet<String> productIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    productIds.addAll(_box.keys.map((key) => key.toString()));
  }

  List<Product> get items => Get.find<ProductController>()
      .products
      .where((product) => productIds.contains(product.id))
      .toList();

  bool contains(String id) => productIds.contains(id);

  void toggle(Product product) {
    if (contains(product.id)) {
      productIds.remove(product.id);
      _box.delete(product.id);
      Get.snackbar(
        'Removed',
        'Removed from wishlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } else {
      productIds.add(product.id);
      _box.put(product.id, true);
      Get.snackbar(
        'Saved to Wishlist',
        product.name,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void addAllToCart() {
    final cart = Get.find<CartController>();
    for (final product in items) {
      cart.add(product, showNotification: false);
    }
    Get.snackbar(
      'Bag Updated',
      'All saved items added to your bag!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  void select(int index) => selectedIndex.value = index;
}

class AuthController extends GetxController {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  final RxBool isLoggedIn = false.obs;

  Future<bool> login(String email, String password) async {
    if (!GetUtils.isEmail(email.trim()) || password.trim().length < 6) {
      Get.snackbar(
        'Check your details',
        'Enter a valid email and password (6+ characters).',
      );
      return false;
    }
    isLoggedIn.value = true;
    await _preferences.setBool('isLoggedIn', true);
    Get.snackbar('Welcome back', 'You are signed in for this demo.');
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    if (name.trim().isEmpty ||
        !GetUtils.isEmail(email.trim()) ||
        password.trim().length < 6) {
      Get.snackbar(
        'Check your details',
        'Add your name, valid email, and 6+ character password.',
      );
      return false;
    }
    await Get.find<ProfileController>().saveProfile(name.trim(), email.trim());
    isLoggedIn.value = true;
    await _preferences.setBool('isLoggedIn', true);
    Get.snackbar(
      'Account ready',
      'Your demo profile has been saved on this device.',
    );
    return true;
  }

  Future<void> signOut() async {
    isLoggedIn.value = false;
    await _preferences.setBool('isLoggedIn', false);
    Get.snackbar('Signed out', 'You have been signed out of the demo.');
  }
}

class ProfileController extends GetxController {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  final RxString name = 'Alex Morgan'.obs;
  final RxString email = 'alex.morgan@email.com'.obs;
  final RxString phone = '+1 555 010 2040'.obs;
  final RxString address = '24 Market Street, San Francisco'.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool darkModeEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    name.value = await _preferences.getString('profileName') ?? name.value;
    email.value = await _preferences.getString('profileEmail') ?? email.value;
    phone.value = await _preferences.getString('profilePhone') ?? phone.value;
    address.value =
        await _preferences.getString('profileAddress') ?? address.value;
    notificationsEnabled.value =
        await _preferences.getBool('notifications') ??
            notificationsEnabled.value;
    darkModeEnabled.value =
        await _preferences.getBool('darkMode') ?? darkModeEnabled.value;
    // Apply saved theme mode
    Get.changeThemeMode(darkModeEnabled.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> saveProfile(
    String newName,
    String newEmail, {
    String? newPhone,
    String? newAddress,
  }) async {
    name.value = newName;
    email.value = newEmail;
    if (newPhone != null) phone.value = newPhone;
    if (newAddress != null) address.value = newAddress;
    await _preferences.setString('profileName', name.value);
    await _preferences.setString('profileEmail', email.value);
    await _preferences.setString('profilePhone', phone.value);
    await _preferences.setString('profileAddress', address.value);
    Get.snackbar('Profile saved', 'Your changes are saved on this device.');
  }

  Future<void> saveAddress(String newAddress) async {
    address.value = newAddress;
    await _preferences.setString('profileAddress', newAddress);
    Get.snackbar('Address saved', 'Your delivery address has been updated.');
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled.value = value;
    await _preferences.setBool('notifications', value);
  }

  Future<void> setDarkMode(bool value) async {
    darkModeEnabled.value = value;
    await _preferences.setBool('darkMode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}

class OrderController extends GetxController {
  final Box _box = Hive.box('orders');
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxString selectedPayment = 'Credit / debit card'.obs;

  @override
  void onInit() {
    super.onInit();
    orders.assignAll(
      _box.values
          .map(
            (value) =>
                OrderModel.fromMap(Map<dynamic, dynamic>.from(value as Map)),
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  Future<OrderModel> placeOrder(
      double total, int itemCount, List<String> productIds) async {
    final now = DateTime.now();
    final order = OrderModel(
      id: 'SE${now.millisecondsSinceEpoch.toString().substring(7)}',
      date: '${now.month}/${now.day}/${now.year}',
      total: total,
      itemCount: itemCount,
      status: 'Processing',
      productIds: productIds,
    );
    await _box.put(order.id, order.toMap());
    orders.insert(0, order);

    Get.find<NotificationController>().addNotification(
      title: 'Order #${order.id} Placed',
      message:
          'Your order of $itemCount items totaling \$${total.toStringAsFixed(2)} was received.',
      isOrder: true,
    );
    return order;
  }

  void reorder(OrderModel order) {
    final productCtrl = Get.find<ProductController>();
    final cartCtrl = Get.find<CartController>();
    int addedCount = 0;
    for (final id in order.productIds) {
      final product = productCtrl.products.firstWhereOrNull((p) => p.id == id);
      if (product != null) {
        cartCtrl.add(product, showNotification: false);
        addedCount++;
      }
    }
    if (addedCount > 0) {
      Get.snackbar(
        'Reordered!',
        '$addedCount items added back to your bag.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<NavigationController>().select(2);
    }
  }
}
