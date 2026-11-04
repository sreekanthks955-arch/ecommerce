import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  String _selectedTag = 'Home';

  @override
  void initState() {
    super.initState();
    final profile = Get.find<ProfileController>();
    _addressController = TextEditingController(text: profile.address.value);
    _phoneController = TextEditingController(text: profile.phone.value);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Address')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Saved Contact Info',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.border,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: isDark
                      ? const Color(0xFF1E284A)
                      : const Color(0xFFEEF2FF),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppTheme.blue,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => Text(
                    profile.name.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Address Tag selector
          Row(
            children: ['Home', 'Office', 'Other'].map((tag) {
              final isSelected = _selectedTag == tag;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedTag = tag),
                  selectedColor: AppTheme.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _addressController,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Street Address & Apartment',
              prefixIcon: Icon(Icons.location_on_outlined),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Save Address Details',
            onPressed: () async {
              if (_addressController.text.trim().isEmpty ||
                  _phoneController.text.trim().isEmpty) {
                Get.snackbar(
                  'Details Needed',
                  'Please provide both a delivery address and phone number.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              await profile.saveProfile(
                profile.name.value,
                profile.email.value,
                newPhone: _phoneController.text.trim(),
                newAddress: _addressController.text.trim(),
              );
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrderController>();
    final isDark = AppTheme.isDark(context);

    const methods = [
      ('Credit / Debit Card', Icons.credit_card_outlined),
      ('Apple Pay / Google Pay', Icons.contactless_outlined),
      ('Cash on Delivery', Icons.payments_outlined),
      ('Demo Digital Wallet', Icons.account_balance_wallet_outlined),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Select preferred demo payment method',
              style: TextStyle(
                color: AppTheme.subtleColor(context),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ...methods.map((method) {
              final selected = orders.selectedPayment.value == method.$1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => orders.selectedPayment.value = method.$1,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? (isDark
                              ? const Color(0xFF1E284A)
                              : const Color(0xFFEEF2FF))
                          : AppTheme.surfaceColor(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? AppTheme.blue
                            : (isDark
                                ? AppTheme.darkBorder
                                : AppTheme.border),
                        width: selected ? 1.6 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: selected
                              ? AppTheme.blue
                              : (isDark
                                  ? const Color(0xFF1E283E)
                                  : const Color(0xFFF1F5F9)),
                          child: Icon(
                            method.$2,
                            color: selected ? Colors.white : AppTheme.blue,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            method.$1,
                            style: TextStyle(
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(
                          selected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: selected ? AppTheme.blue : AppTheme.muted,
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161F2E)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 18, color: AppTheme.muted),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No real credit card numbers or banking credentials are saved or charged in this demo.',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 11.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save & Return to Checkout',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
