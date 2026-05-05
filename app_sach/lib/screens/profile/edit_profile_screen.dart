import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _ctrl = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _selectedGender = '';
  String _selectedBirthDate = '';

  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];

  @override
  void initState() {
    super.initState();
    final user = _ctrl.currentUser.value;
    _nameCtrl.text = user?.fullName ?? '';
    _phoneCtrl.text = user?.phone ?? '';
    _selectedGender = user?.gender ?? '';
    _selectedBirthDate = user?.birthDate ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime(2000);
    if (_selectedBirthDate.isNotEmpty) {
      final parts = _selectedBirthDate.split('/');
      if (parts.length == 3) {
        initial = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        _nameCtrl.text.isNotEmpty
                            ? _nameCtrl.text[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              _sectionLabel('Thông tin cá nhân'),
              const SizedBox(height: 12),

              // Họ tên
              TextFormField(
                controller: _nameCtrl,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Nhập họ tên' : null,
                onChanged: (_) => setState(() {}),
                decoration: _deco('Họ và tên', Icons.person_outline),
              ),
              const SizedBox(height: 14),

              // Email (readonly)
              TextFormField(
                initialValue: _ctrl.currentUser.value?.email ?? '',
                readOnly: true,
                decoration: _deco('Email', Icons.email_outlined).copyWith(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  suffixIcon: const Icon(Icons.lock_outline,
                      color: Colors.grey, size: 18),
                ),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 14),

              // Số điện thoại
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: _deco('Số điện thoại', Icons.phone_outlined),
              ),
              const SizedBox(height: 14),

              // Giới tính
              const Text('Giới tính',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: _genders.map((g) {
                  final selected = _selectedGender == g;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGender = g),
                      child: Container(
                        margin: EdgeInsets.only(
                            right: g != _genders.last ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(g,
                              style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Ngày sinh
              const Text('Ngày sinh',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _selectedBirthDate.isNotEmpty
                            ? _selectedBirthDate
                            : 'Chọn ngày sinh',
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedBirthDate.isNotEmpty
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Obx(() => AppButton(
                text: 'Lưu thay đổi',
                isLoading: _ctrl.isLoading.value,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = _ctrl.currentUser.value!.copyWith(
                      fullName: _nameCtrl.text.trim(),
                      phone: _phoneCtrl.text.trim(),
                      gender: _selectedGender,
                      birthDate: _selectedBirthDate,
                    );
                    _ctrl.updateProfile(user);
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary),
  );

  InputDecoration _deco(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primary),
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}