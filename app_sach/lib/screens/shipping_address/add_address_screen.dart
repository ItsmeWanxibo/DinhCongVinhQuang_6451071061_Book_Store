import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/order_controller.dart';
import '../../data/models/order_model.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _distCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _ctrl = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm địa chỉ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ...[
                (_nameCtrl, 'Họ và tên', Icons.person_outline),
                (_phoneCtrl, 'Số điện thoại', Icons.phone_outlined),
                (_addrCtrl, 'Địa chỉ', Icons.home_outlined),
                (_distCtrl, 'Quận/Huyện', Icons.location_on_outlined),
                (_cityCtrl, 'Tỉnh/Thành phố', Icons.location_city),
              ].map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: e.$1,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Vui lòng nhập ${e.$2}'
                      : null,
                  decoration: InputDecoration(
                    labelText: e.$2,
                    prefixIcon: Icon(e.$3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )),
              const SizedBox(height: 12),
              AppButton(
                text: 'Lưu địa chỉ',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _ctrl.addAddress(AddressModel(
                      fullName: _nameCtrl.text.trim(),
                      phone: _phoneCtrl.text.trim(),
                      address: _addrCtrl.text.trim(),
                      district: _distCtrl.text.trim(),
                      city: _cityCtrl.text.trim(),
                    ));
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}