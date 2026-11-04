import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/app_controllers.dart';
import 'pages/splash/splash_screen.dart';
import 'services/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox<int>('cart'),
    Hive.openBox<bool>('wishlist'),
    Hive.openBox('products'),
    Hive.openBox('orders'),
  ]);

  Get.put(NotificationController(), permanent: true);
  Get.put(ProductController(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(WishlistController(), permanent: true);
  Get.put(NavigationController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(OrderController(), permanent: true);

  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      return GetMaterialApp(
        title: 'ShopEase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const SplashScreen(),
      );
    }

    final profile = Get.find<ProfileController>();
    return Obx(
      () => GetMaterialApp(
        title: 'ShopEase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: profile.darkModeEnabled.value
            ? ThemeMode.dark
            : ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
