import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/auth_controller.dart';
import '../../utils/validators.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.lock_reset,
                  size: 80, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text(
                'Nhập email để nhận link đặt lại mật khẩu',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: ctrl,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => AppButton(
                text: 'Gửi email',
                isLoading: authCtrl.isLoading.value,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    authCtrl.forgotPassword(ctrl.text.trim());
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}