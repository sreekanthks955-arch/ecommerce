import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../services/app_theme.dart';
import '../products/product_screens.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Get.find<ProductController>();
    final isDark = AppTheme.isDark(context);

    const icons = {
      'Electronics': Icons.devices_rounded,
      'Fashion': Icons.checkroom_rounded,
      'Home': Icons.weekend_rounded,
      'Beauty': Icons.spa_rounded,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 16),
            child: Text(
              'Browse departments curated for high quality & modern lifestyle',
              style: TextStyle(
                color: AppTheme.subtleColor(context),
                fontSize: 12.5,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
              itemCount: products.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.10,
              ),
              itemBuilder: (context, index) {
                final category = products.categories[index];
                final isAll = category == 'All';
                final icon = isAll ? Icons.grid_view_rounded : icons[category]!;
                final itemCount = isAll
                    ? products.products.length
                    : products.products
                        .where((product) => product.category == category)
                        .length;

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    products.selectCategory(category);
                    Get.to(
                      () => ProductListingScreen(
                        title: isAll ? 'All Products' : category,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? AppTheme.darkBorder : AppTheme.border,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isDark
                              ? const Color(0xFF1E284A)
                              : const Color(0xFFEEF2FF),
                          child: Icon(icon, color: AppTheme.blue, size: 24),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                color: AppTheme.textColor(context),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$itemCount products',
                              style: TextStyle(
                                color: AppTheme.subtleColor(context),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
