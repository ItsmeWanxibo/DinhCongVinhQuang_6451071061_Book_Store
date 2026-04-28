import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/order_controller.dart';
import '../../controller/cart_controller.dart';
import '../../utils/format_utils.dart';
import '../../data/models/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _orderCtrl = Get.find<OrderController>();
  final _cartCtrl = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thông tin giao hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _field(_nameCtrl, 'Họ và tên', Icons.person_outline),
              const SizedBox(height: 12),
              _field(_phoneCtrl, 'Số điện thoại', Icons.phone_outlined,
                  type: TextInputType.phone),
              const SizedBox(height: 12),
              _field(_addressCtrl, 'Địa chỉ', Icons.home_outlined),
              const SizedBox(height: 12),
              _field(_districtCtrl, 'Quận/Huyện', Icons.location_on_outlined),
              const SizedBox(height: 12),
              _field(_cityCtrl, 'Tỉnh/Thành phố', Icons.location_city),
              const SizedBox(height: 20),

              const Text('Phương thức thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(() => Column(
                children: ['COD', 'Banking'].map((method) {
                  return RadioListTile<String>(
                    value: method,
                    groupValue: _orderCtrl.paymentMethod.value,
                    onChanged: (v) =>
                    _orderCtrl.paymentMethod.value = v!,
                    title: Text(method == 'COD'
                        ? 'Thanh toán khi nhận hàng'
                        : 'Chuyển khoản ngân hàng'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Số sản phẩm:'),
                        Obx(() => Text('${_cartCtrl.totalItems}')),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng tiền:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() => Text(
                          FormatUtils.formatPrice(_cartCtrl.totalPrice),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 16),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Obx(() => AppButton(
                text: 'Đặt hàng',
                isLoading: _orderCtrl.isLoading.value,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _orderCtrl.selectedAddress.value = AddressModel(
                      fullName: _nameCtrl.text.trim(),
                      phone: _phoneCtrl.text.trim(),
                      address: _addressCtrl.text.trim(),
                      district: _districtCtrl.text.trim(),
                      city: _cityCtrl.text.trim(),
                    );
                    _orderCtrl.placeOrder();
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController ctrl,
      String label,
      IconData icon, {
        TextInputType type = TextInputType.text,
      }) =>
      TextFormField(
        controller: ctrl,
        keyboardType: type,
        validator: (v) =>
        v == null || v.trim().isEmpty ? 'Vui lòng nhập $label' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
}