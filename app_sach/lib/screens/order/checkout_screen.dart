import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/order_controller.dart';
import '../../controller/cart_controller.dart';
import '../../data/models/order_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/format_utils.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _distCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _orderCtrl = Get.find<OrderController>();
  final _cartCtrl = Get.find<CartController>();

  bool _useExistingAddress = false;
  bool _loadingAddress = true;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    await _orderCtrl.loadAddresses();
    setState(() => _loadingAddress = false);

    // Nếu đã có địa chỉ → tự điền và dùng luôn
    if (_orderCtrl.addresses.isNotEmpty) {
      final addr = _orderCtrl.addresses.first;
      setState(() {
        _useExistingAddress = true;
        _nameCtrl.text = addr.fullName;
        _phoneCtrl.text = addr.phone;
        _addrCtrl.text = addr.address;
        _distCtrl.text = addr.district;
        _cityCtrl.text = addr.city;
        _orderCtrl.selectedAddress.value = addr;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addrCtrl.dispose();
    _distCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingAddress) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Thanh toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chọn địa chỉ đã lưu nếu có
              if (_orderCtrl.addresses.isNotEmpty) ...[
                _sectionTitle('Địa chỉ giao hàng'),
                const SizedBox(height: 8),

                // Toggle dùng địa chỉ đã lưu / nhập mới
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      // Địa chỉ đã lưu
                      ..._orderCtrl.addresses.asMap().entries.map((e) {
                        final i = e.key;
                        final addr = e.value;
                        final selected =
                            _orderCtrl.selectedAddress.value == addr &&
                                _useExistingAddress;
                        return RadioListTile<AddressModel>(
                          value: addr,
                          groupValue: _useExistingAddress
                              ? _orderCtrl.selectedAddress.value
                              : null,
                          onChanged: (v) {
                            setState(() {
                              _useExistingAddress = true;
                              _orderCtrl.selectedAddress.value = v;
                              _nameCtrl.text = v!.fullName;
                              _phoneCtrl.text = v.phone;
                              _addrCtrl.text = v.address;
                              _distCtrl.text = v.district;
                              _cityCtrl.text = v.city;
                            });
                          },
                          title: Text(addr.fullName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          subtitle: Text(
                            '${addr.phone}\n${addr.fullAddress}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          isThreeLine: true,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }),

                      const Divider(height: 1),

                      // Dùng địa chỉ mới
                      RadioListTile<bool>(
                        value: false,
                        groupValue: _useExistingAddress,
                        onChanged: (v) {
                          setState(() {
                            _useExistingAddress = false;
                            _nameCtrl.clear();
                            _phoneCtrl.clear();
                            _addrCtrl.clear();
                            _distCtrl.clear();
                            _cityCtrl.clear();
                            _orderCtrl.selectedAddress.value = null;
                          });
                        },
                        title: const Text('Nhập địa chỉ mới',
                            style: TextStyle(fontSize: 14)),
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Form nhập địa chỉ (hiện khi chọn "Nhập mới" hoặc chưa có địa chỉ)
              if (!_useExistingAddress ||
                  _orderCtrl.addresses.isEmpty) ...[
                _sectionTitle('Thông tin giao hàng'),
                const SizedBox(height: 12),
                _field(_nameCtrl, 'Họ và tên', Icons.person_outline),
                const SizedBox(height: 12),
                _field(_phoneCtrl, 'Số điện thoại', Icons.phone_outlined,
                    type: TextInputType.phone),
                const SizedBox(height: 12),
                _field(_addrCtrl, 'Địa chỉ', Icons.home_outlined),
                const SizedBox(height: 12),
                _field(_distCtrl, 'Quận/Huyện',
                    Icons.location_on_outlined),
                const SizedBox(height: 12),
                _field(_cityCtrl, 'Tỉnh/Thành phố',
                    Icons.location_city_outlined),
                const SizedBox(height: 16),
              ],

              // Phương thức thanh toán
              _sectionTitle('Phương thức thanh toán'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Obx(() => Column(
                  children: [
                    _paymentTile('COD', 'Thanh toán khi nhận hàng',
                        Icons.local_shipping_outlined),
                    const Divider(height: 1),
                    _paymentTile('Banking', 'Chuyển khoản ngân hàng',
                        Icons.account_balance_outlined),
                  ],
                )),
              ),
              const SizedBox(height: 16),

              // Tóm tắt đơn hàng
              _sectionTitle('Tóm tắt đơn hàng'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ..._cartCtrl.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name +
                                  (item.variant.isNotEmpty
                                      ? ' (${item.variant})'
                                      : ''),
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('x${item.quantity}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13)),
                          const SizedBox(width: 8),
                          Text(
                            FormatUtils.formatPrice(item.subtotal),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phí vận chuyển:'),
                        const Text('Miễn phí',
                            style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng cộng:',
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() => Text(
                          FormatUtils.formatPrice(
                              _cartCtrl.totalPrice),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                              fontSize: 18),
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
                onPressed: () => _submitOrder(),
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _submitOrder() {
    // Nếu dùng địa chỉ mới thì validate form
    if (!_useExistingAddress || _orderCtrl.addresses.isEmpty) {
      if (!_formKey.currentState!.validate()) return;
      _orderCtrl.selectedAddress.value = AddressModel(
        fullName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addrCtrl.text.trim(),
        district: _distCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
      );
    }

    if (_orderCtrl.selectedAddress.value == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn địa chỉ giao hàng',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _orderCtrl.placeOrder();
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary),
  );

  Widget _paymentTile(String value, String title, IconData icon) =>
      RadioListTile<String>(
        value: value,
        groupValue: _orderCtrl.paymentMethod.value,
        onChanged: (v) => _orderCtrl.paymentMethod.value = v!,
        title: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
        activeColor: AppColors.primary,
      );

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
        v == null || v.trim().isEmpty ? 'Nhập $label' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      );
}