import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../onboarding/onboarding_screen.dart';
import '../../services/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1100), () {
      if (mounted) Get.off(() => const OnboardingScreen());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white24,
              child: Icon(Icons.shopping_bag_rounded, size: 40, color: Colors.white),
            ),
            SizedBox(height: 18),
            Text('ShopEase', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: Colors.white)),
            SizedBox(height: 5),
            Text('Better Shopping. Better Living.', style: TextStyle(fontSize: 12, color: Colors.white70)),
            SizedBox(height: 24),
            SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      ),
    );
  }
}
