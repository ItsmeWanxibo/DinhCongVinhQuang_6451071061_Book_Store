import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/order_controller.dart';
import '../../routes/app_routes.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});
  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _ctrl = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    _ctrl.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Địa chỉ giao hàng')),
      body: Obx(() => _ctrl.addresses.isEmpty
          ? const Center(child: Text('Chưa có địa chỉ'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _ctrl.addresses.length,
        itemBuilder: (_, i) {
          final addr = _ctrl.addresses[i];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(addr.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  '${addr.phone}\n${addr.fullAddress}'),
              isThreeLine: true,
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addAddress),
        child: const Icon(Icons.add),
      ),
    );
  }
}