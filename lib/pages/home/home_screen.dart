import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';
import '../cart/cart_screen.dart';
import '../categories/categories_screen.dart';
import '../notifications/notifications_screen.dart';
import '../products/product_screens.dart';
import '../profile/profile_screen.dart';

class ShopShell extends StatelessWidget {
  const ShopShell({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = Get.find<NavigationController>();
    final cart = Get.find<CartController>();

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navigation.selectedIndex.value,
          children: const [
            HomeScreen(),
            CategoriesScreen(),
            CartScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => PremiumBottomNavBar(
          selectedIndex: navigation.selectedIndex.value,
          onTap: navigation.select,
          cartCount: cart.itemCount,
        ),
      ),
    );
  }
}

class PremiumBottomNavBar extends StatelessWidget {
  const PremiumBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.cartCount,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.darkBorder : const Color(0xFFE8ECF4),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : const Color(0x100E1A36),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                selectedIndex: selectedIndex,
                onTap: onTap,
                inactiveIcon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
              ),
              _NavItem(
                index: 1,
                selectedIndex: selectedIndex,
                onTap: onTap,
                inactiveIcon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view_rounded,
                label: 'Categories',
              ),
              _NavItem(
                index: 2,
                selectedIndex: selectedIndex,
                onTap: onTap,
                inactiveIcon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag_rounded,
                label: 'Bag',
                badgeCount: cartCount,
              ),
              _NavItem(
                index: 3,
                selectedIndex: selectedIndex,
                onTap: onTap,
                inactiveIcon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.inactiveIcon,
    required this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final IconData inactiveIcon;
  final IconData activeIcon;
  final String label;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final isDark = AppTheme.isDark(context);

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(18),
      splashColor: AppTheme.blue.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF1E284A)
                  : const Color(0xFFEEF2FF))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    color: isSelected
                        ? (isDark ? const Color(0xFF7585FF) : AppTheme.blue)
                        : AppTheme.subtleColor(context),
                    size: 22,
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -5,
                    right: -9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blue,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.blue.withValues(alpha: 0.35),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? const Color(0xFF7585FF) : AppTheme.blue)
                    : AppTheme.subtleColor(context),
                letterSpacing: -0.1,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 12 : 0,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF7585FF) : AppTheme.blue)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients) {
        final next = (_currentBanner + 1) % 3;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = AppTheme.isDark(context);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter & Sort',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            productCtrl.resetFilters();
                            setModalState(() {});
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'SORT BY',
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
                      runSpacing: 8,
                      children: [
                        'Featured',
                        'Price: low to high',
                        'Price: high to low',
                        'Top rated',
                        'Biggest discount',
                      ].map((option) {
                        final selected = productCtrl.sortBy.value == option;
                        return ChoiceChip(
                          label: Text(option),
                          selected: selected,
                          onSelected: (_) {
                            productCtrl.setSort(option);
                            setModalState(() {});
                          },
                          selectedColor: AppTheme.blue,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : null,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PRICE RANGE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          '\$${productCtrl.minPrice.value.round()} - \$${productCtrl.maxPrice.value.round()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppTheme.blue,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(
                        productCtrl.minPrice.value,
                        productCtrl.maxPrice.value,
                      ),
                      min: 0,
                      max: 200,
                      divisions: 20,
                      activeColor: AppTheme.blue,
                      onChanged: (values) {
                        productCtrl.setPriceRange(values.start, values.end);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label:
                          'Apply Filters (${productCtrl.filteredProducts.length} items)',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();
    final productCtrl = Get.find<ProductController>();
    final cartCtrl = Get.find<CartController>();
    final notifCtrl = Get.find<NotificationController>();
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 21,
                                backgroundColor: isDark
                                    ? const Color(0xFF1E284A)
                                    : const Color(0xFFEEF2FF),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: AppTheme.blue,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Good day, ${profile.name.value.split(' ').first} ✨',
                                      style: TextStyle(
                                        color: AppTheme.subtleColor(context),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Obx(
                                      () => Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 13,
                                            color: AppTheme.blue,
                                          ),
                                          const SizedBox(width: 2),
                                          Flexible(
                                            child: Text(
                                              profile.address.value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.textColor(context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Notification Bell
                    IconButton(
                      onPressed: () => Get.to(() => const NotificationsScreen()),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.surfaceColor(context),
                        side: BorderSide(
                          color: isDark ? AppTheme.darkBorder : AppTheme.border,
                        ),
                      ),
                      icon: Obx(
                        () => Badge(
                          label: Text('${notifCtrl.unreadCount}'),
                          isLabelVisible: notifCtrl.unreadCount > 0,
                          backgroundColor: AppTheme.rose,
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: AppTheme.textColor(context),
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Cart Bag
                    IconButton(
                      onPressed: () => Get.to(() => const CartScreen()),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.surfaceColor(context),
                        side: BorderSide(
                          color: isDark ? AppTheme.darkBorder : AppTheme.border,
                        ),
                      ),
                      icon: Obx(
                        () => Badge(
                          label: Text('${cartCtrl.itemCount}'),
                          isLabelVisible: cartCtrl.itemCount > 0,
                          backgroundColor: AppTheme.blue,
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: AppTheme.textColor(context),
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar & Filter trigger
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(() => const SearchScreen()),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppTheme.darkBorder
                                  : const Color(0xFFE5E7EB),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : const Color(0x060F172A),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: AppTheme.subtleColor(context),
                                size: 21,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Search products, brands...',
                                style: TextStyle(
                                  color: AppTheme.subtleColor(context),
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => _showFilterModal(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E284A)
                              : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.blue.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppTheme.blue,
                          size: 21,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Promotional Carousel Banner
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: PageView(
                        controller: _bannerController,
                        onPageChanged: (i) => setState(() => _currentBanner = i),
                        children: [
                          // Slide 1: Flash Sale with Countdown
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B50DF), Color(0xFF6366F1)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B50DF).withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'FLASH SALE ⚡',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const FlashDealTimer(),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Up to 50% Off\nSelected Items',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      InkWell(
                                        onTap: () => Get.to(
                                          () => const ProductListingScreen(
                                            title: 'Flash Sale Deals',
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Text(
                                              'Shop Now',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.headphones_rounded,
                                  size: 78,
                                  color: Color(0x35FFFFFF),
                                ),
                              ],
                            ),
                          ),

                          // Slide 2: Trending Audio & Electronics
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'NEW SEASON',
                                        style: TextStyle(
                                          color: AppTheme.amber,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'Studio Acoustic\nSound System',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          productCtrl.selectCategory('Electronics');
                                          Get.find<NavigationController>().select(1);
                                        },
                                        child: const Row(
                                          children: [
                                            Text(
                                              'Discover',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.speaker_rounded,
                                  size: 78,
                                  color: Color(0x25FFFFFF),
                                ),
                              ],
                            ),
                          ),

                          // Slide 3: Voucher Code Promo
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF065F46), Color(0xFF059669)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'CODE: SAVE10',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'Extra 10% Off\nYour First Bag',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Apply at checkout · All orders',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.confirmation_number_outlined,
                                  size: 78,
                                  color: Color(0x25FFFFFF),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Dots indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 5,
                          width: _currentBanner == index ? 18 : 6,
                          decoration: BoxDecoration(
                            color: _currentBanner == index
                                ? AppTheme.blue
                                : (isDark
                                    ? Colors.white24
                                    : const Color(0xFFD1D5DB)),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: SectionHeading(
                  title: 'Shop by Category',
                  actionLabel: 'See all',
                  onAction: () => Get.find<NavigationController>().select(1),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 98,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: productCtrl.categories.length - 1,
                  separatorBuilder: (context, index) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final category = productCtrl.categories[index + 1];
                    final icons = [
                      Icons.devices_rounded,
                      Icons.checkroom_rounded,
                      Icons.chair_rounded,
                      Icons.spa_rounded,
                    ];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        productCtrl.selectCategory(category);
                        Get.find<NavigationController>().select(1);
                      },
                      child: SizedBox(
                        width: 72,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: isDark
                                  ? const Color(0xFF1E284A)
                                  : const Color(0xFFEEF2FF),
                              child: Icon(
                                icons[index],
                                color: AppTheme.blue,
                                size: 23,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Flash Deals Horizontal Shelf
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'Flash Deals',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.rose.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'LIMITED',
                              style: TextStyle(
                                color: AppTheme.rose,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(
                        () => const ProductListingScreen(
                          title: 'Flash Deals',
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View all',
                            style: TextStyle(
                              color: AppTheme.blue,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: AppTheme.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 265,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: productCtrl.flashSaleProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = productCtrl.flashSaleProducts[index];
                    return SizedBox(
                      width: 165,
                      child: ProductCard(
                        product: product,
                        compact: true,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Curated Catalog Section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: SectionHeading(
                  title: 'Popular Essentials',
                  actionLabel: 'See all',
                  onAction: () => Get.to(
                    () => const ProductListingScreen(title: 'All Products'),
                  ),
                ),
              ),
            ),
            Obx(() {
              final products = productCtrl.products.toList();
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.60,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
