import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_screens.dart';
import '../home/home_screen.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  final List<({IconData icon, String title, String description})> _slides = const [
    (
      icon: Icons.shopping_cart_rounded,
      title: 'Wide Range\nof Products',
      description: 'Discover new finds and trusted essentials, all in one place.',
    ),
    (
      icon: Icons.local_shipping_rounded,
      title: 'Fast & Reliable\nDelivery',
      description: 'Get your favorite finds delivered right to your doorstep.',
    ),
    (
      icon: Icons.verified_user_rounded,
      title: 'Secure Payments',
      description: 'Choose a demo payment option for a simple checkout experience.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.offAll(() => const ShopShell()),
                  child: const Text('Skip', style: TextStyle(color: AppTheme.muted)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 245,
                          width: 245,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(95),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEAF0FF), Color(0xFFF3EDFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(slide.icon, size: 105, color: AppTheme.blue),
                        ),
                        const SizedBox(height: 34),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 25, height: 1.2),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.muted, height: 1.5),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 7,
                    width: _page == index ? 19 : 7,
                    decoration: BoxDecoration(
                      color: _page == index ? AppTheme.blue : const Color(0xFFD8DCEF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              PrimaryButton(
                label: _page == _slides.length - 1 ? 'Get started' : 'Next',
                onPressed: () {
                  if (_page == _slides.length - 1) {
                    Get.to(() => const RegisterScreen());
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
                icon: _page == _slides.length - 1 ? Icons.arrow_forward : null,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.to(() => const LoginScreen()),
                child: const Text('I already have an account', style: TextStyle(color: AppTheme.blue, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
