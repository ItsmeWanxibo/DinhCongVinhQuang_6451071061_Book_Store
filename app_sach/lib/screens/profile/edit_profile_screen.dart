import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _ctrl = Get.find<AuthController>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = _ctrl.currentUser.value?.fullName ?? '';
    _phoneCtrl.text = _ctrl.currentUser.value?.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneCtrl,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => AppButton(
              text: 'Lưu',
              isLoading: _ctrl.isLoading.value,
              onPressed: () {
                final user = _ctrl.currentUser.value!.copyWith(
                  fullName: _nameCtrl.text.trim(),
                  phone: _phoneCtrl.text.trim(),
                );
                _ctrl.updateProfile(user);
              },
            )),
          ],
        ),
      ),
    );
  }
}