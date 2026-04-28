import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/auth_controller.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;
  final AuthController _authCtrl = Get.find();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text('Đăng ký',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                validator: (v) => Validators.required(v, 'Họ tên'),
                decoration: _inputDeco('Họ và tên', Icons.person_outline),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDeco('Email', Icons.email_outlined),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _obscureConfirm,
                validator: (v) {
                  if (v != _passCtrl.text) return 'Mật khẩu không khớp';
                  return null;
                },
                decoration: _inputDeco(
                    'Xác nhận mật khẩu', Icons.lock_outline)
                    .copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Obx(() => AppButton(
                text: 'Đăng ký',
                isLoading: _authCtrl.isLoading.value,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _authCtrl.register(
                      email: _emailCtrl.text.trim(),
                      password: _passCtrl.text,
                      fullName: _nameCtrl.text.trim(),
                    );
                  }
                },
              )),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã có tài khoản? ',
                      style: TextStyle(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text('Đăng nhập',
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
    );
  }
}