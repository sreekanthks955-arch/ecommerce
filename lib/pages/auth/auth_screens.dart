import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final success = await Get.find<AuthController>().login(
      _emailController.text,
      _passwordController.text,
    );
    if (success) Get.offAll(() => const ShopShell());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_person_rounded, size: 45, color: AppTheme.blue),
              const SizedBox(height: 22),
              Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text('Sign in to continue shopping.', style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 34),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.snackbar('Demo sign in', 'Use any valid email and a password of 6+ characters.'),
                  child: const Text('Forgot password?', style: TextStyle(color: AppTheme.blue)),
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(label: 'Sign in', onPressed: _login),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () => Get.to(() => const RegisterScreen()),
                  child: const Text('New here? Create an account', style: TextStyle(color: AppTheme.blue)),
                ),
              ),
              const SizedBox(height: 8),
              const Center(child: Text('Demo only — no real authentication', style: TextStyle(color: AppTheme.muted, fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final success = await Get.find<AuthController>().register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (success) Get.offAll(() => const ShopShell());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_add_alt_1_rounded, size: 43, color: AppTheme.blue),
              const SizedBox(height: 20),
              Text('Create account', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text('Your new favorite finds are just ahead.', style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 28),
              TextField(controller: _nameController, textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 14),
              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline))),
              const SizedBox(height: 14),
              TextField(controller: _passwordController, obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password (6+ characters)', prefixIcon: Icon(Icons.lock_outline))),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Create account', onPressed: _register),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Already have an account? Sign in', style: TextStyle(color: AppTheme.blue)),
                ),
              ),
              const Center(child: Text('Your details stay on this device.', style: TextStyle(color: AppTheme.muted, fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }
}
