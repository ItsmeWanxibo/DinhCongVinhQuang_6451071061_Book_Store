import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../controller/auth_controller.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const ProfileScreenInTab();
}

class ProfileScreenInTab extends StatelessWidget {
  const ProfileScreenInTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cá nhân')),
      body: Obx(() {
        final user = ctrl.currentUser.value;
        if (user == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              child: const Text('Đăng nhập'),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: AppColors.primary,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Text(
                        user.fullName.isNotEmpty
                            ? user.fullName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user.fullName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(user.email,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Menu
              _menuItem(Icons.person_outline, 'Chỉnh sửa hồ sơ',
                      () => Get.toNamed(AppRoutes.editProfile)),
              _menuItem(Icons.location_on_outlined, 'Địa chỉ giao hàng',
                      () => Get.toNamed(AppRoutes.shippingAddress)),
              _menuItem(Icons.receipt_outlined, 'Đơn hàng của tôi',
                      () => Get.toNamed(AppRoutes.orderList)),
              _menuItem(Icons.favorite_outline, 'Yêu thích',
                      () => Get.toNamed(AppRoutes.wishlist)),
              _menuItem(Icons.notifications_outlined, 'Thông báo',
                      () => Get.toNamed(AppRoutes.notifications)),

              const Divider(height: 1),

              _menuItem(Icons.logout, 'Đăng xuất',
                      () => ctrl.logout(),
                  color: Colors.red),

              const SizedBox(height: 16),

              const Text('MSSV: 6451071061',
                  style: TextStyle(
                      color: AppColors.textHint, fontSize: 12)),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(title,
          style: TextStyle(color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
    );
  }
}