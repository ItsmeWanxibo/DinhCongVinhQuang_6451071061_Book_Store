import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  final AuthController _authCtrl = Get.find();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        size: 44, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),

                const Center(
                  child: Text('Đăng nhập',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text('Chào mừng trở lại!',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 15)),
                ),
                const SizedBox(height: 36),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDeco('Email', Icons.email_outlined),
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  validator: Validators.password,
                  obscureText: _obscure,
                  decoration: _inputDeco('Mật khẩu', Icons.lock_outline)
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscure
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.forgotPassword),
                    child: const Text('Quên mật khẩu?',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 8),

                // Login button
                Obx(() => AppButton(
                  text: 'Đăng nhập',
                  isLoading: _authCtrl.isLoading.value,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authCtrl.login(
                        email: _emailCtrl.text.trim(),
                        password: _passCtrl.text,
                      );
                    }
                  },
                )),

                const SizedBox(height: 24),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Chưa có tài khoản? ',
                        style: TextStyle(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: const Text('Đăng ký',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      );
}