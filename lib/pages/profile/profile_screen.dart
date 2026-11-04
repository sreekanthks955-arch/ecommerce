import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';
import '../checkout/address_payment_screens.dart';
import '../home/home_screen.dart';
import '../orders/order_screens.dart';
import '../wishlist/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();
    final auth = Get.find<AuthController>();
    final orders = Get.find<OrderController>();
    final wishlist = Get.find<WishlistController>();
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            // User Hero Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B50DF), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B50DF).withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          profile.email.value,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _editProfile(context),
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Profile Stats Quick Bar
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Orders',
                    value: '${orders.orders.length}',
                    icon: Icons.receipt_long_rounded,
                    onTap: () => Get.to(() => const OrderHistoryScreen()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Saved',
                    value: '${wishlist.items.length}',
                    icon: Icons.favorite_rounded,
                    onTap: () => Get.to(() => const WishlistScreen()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Coupons',
                    value: '2 active',
                    icon: Icons.local_offer_rounded,
                    onTap: () {
                      Get.snackbar(
                        'Active Coupons',
                        'SAVE10 (10% off) and WELCOME5 (\$5 off) are available!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'ACCOUNT DETAILS',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 10.5,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            _ProfileLink(
              icon: Icons.receipt_long_outlined,
              title: 'Order History',
              subtitle: '${orders.orders.length} placed orders',
              onTap: () => Get.to(() => const OrderHistoryScreen()),
            ),
            _ProfileLink(
              icon: Icons.favorite_border_rounded,
              title: 'Wishlist & Saved',
              subtitle: '${wishlist.items.length} saved products',
              onTap: () => Get.to(() => const WishlistScreen()),
            ),
            _ProfileLink(
              icon: Icons.location_on_outlined,
              title: 'Delivery Address',
              subtitle: profile.address.value,
              onTap: () => Get.to(() => const AddressManagementScreen()),
            ),
            _ProfileLink(
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
              subtitle: orders.selectedPayment.value,
              onTap: () => Get.to(() => const PaymentMethodsScreen()),
            ),

            const SizedBox(height: 20),
            const Text(
              'PREFERENCES & SYSTEM',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 10.5,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            _ProfileLink(
              icon: Icons.settings_outlined,
              title: 'App Settings & Theme',
              subtitle: isDark ? 'Dark appearance' : 'Light appearance',
              onTap: () => Get.to(() => const SettingsScreen()),
            ),
            _ProfileLink(
              icon: Icons.help_outline_rounded,
              title: 'Help & Customer Support',
              subtitle: 'FAQs, warranty & demo guide',
              onTap: () => Get.to(() => const HelpSupportScreen()),
            ),

            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () async {
                await auth.signOut();
                Get.offAll(() => const ShopShell());
              },
              icon: const Icon(Icons.logout_rounded, color: AppTheme.rose),
              label: const Text(
                'Sign out of demo',
                style: TextStyle(color: AppTheme.rose, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final profile = Get.find<ProfileController>();
    final nameController = TextEditingController(text: profile.name.value);
    final emailController = TextEditingController(text: profile.email.value);
    final phoneController = TextEditingController(text: profile.phone.value);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty ||
                  !GetUtils.isEmail(emailController.text.trim())) {
                Get.snackbar(
                  'Check details',
                  'Please enter a name and valid email.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              await profile.saveProfile(
                nameController.text.trim(),
                emailController.text.trim(),
                newPhone: phoneController.text.trim(),
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.border,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.blue, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.subtleColor(context),
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  const _ProfileLink({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.border,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          radius: 19,
          backgroundColor:
              isDark ? const Color(0xFF1E284A) : const Color(0xFFEEF2FF),
          child: Icon(icon, size: 19, color: AppTheme.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppTheme.subtleColor(context),
                ),
              ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
        onTap: onTap,
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'APPEARANCE & NOTIFICATIONS',
              style: TextStyle(
                color: AppTheme.muted,
                letterSpacing: 1.1,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              secondary: const Icon(
                Icons.dark_mode_outlined,
                color: AppTheme.blue,
              ),
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle between sleek dark & light theme'),
              value: profile.darkModeEnabled.value,
              onChanged: profile.setDarkMode,
            ),
            const Divider(),
            SwitchListTile(
              secondary: const Icon(
                Icons.notifications_none_rounded,
                color: AppTheme.blue,
              ),
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive order tracking and deal alerts'),
              value: profile.notificationsEnabled.value,
              onChanged: profile.setNotifications,
            ),
            const SizedBox(height: 20),
            const Text(
              'ABOUT APP',
              style: TextStyle(
                color: AppTheme.muted,
                letterSpacing: 1.1,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded, color: AppTheme.blue),
              title: const Text('Version'),
              subtitle: const Text('ShopEase v2.0 Premium Edition'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: AppTheme.blue),
              title: const Text('Privacy Policy'),
              subtitle: const Text('All data is kept locally in this demo'),
              onTap: () => Get.snackbar('Privacy', 'Your data never leaves this device.'),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'How can we help?',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          const SizedBox(height: 6),
          const Text(
            'Frequently asked questions & customer reassurance.',
            style: TextStyle(color: AppTheme.muted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          const _HelpQuestion(
            question: 'How do I place an order?',
            answer:
                'Browse items, choose your color and size options, and tap "Add to bag". In checkout, select your delivery address and demo payment option to complete.',
          ),
          const _HelpQuestion(
            question: 'How does Dark Mode work?',
            answer:
                'Go to My Profile > Settings and switch Dark Mode on or off. The app dynamically adapts every screen immediately!',
          ),
          const _HelpQuestion(
            question: 'Can I reorder items from past orders?',
            answer:
                'Yes! Under My Orders, simply tap "Reorder items" on any past order to immediately add them back into your bag.',
          ),
          const _HelpQuestion(
            question: 'How do I use promo codes?',
            answer:
                'In your bag, enter SAVE10 for 10% off or WELCOME5 for \$5 off and tap "Apply".',
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Contact Support Concierge',
            icon: Icons.support_agent_rounded,
            onPressed: () => Get.snackbar(
              'Support Concierge',
              'Demo customer support is available 24/7 on device.',
              snackPosition: SnackPosition.BOTTOM,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpQuestion extends StatelessWidget {
  const _HelpQuestion({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Card(
      color: AppTheme.surfaceColor(context),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppTheme.darkBorder : AppTheme.border,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: AppTheme.subtleColor(context),
              height: 1.45,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
