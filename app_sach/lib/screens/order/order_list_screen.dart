import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/order_controller.dart';
import '../../utils/format_utils.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});
  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final _ctrl = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    _ctrl.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng của tôi')),
      body: Obx(() => _ctrl.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _ctrl.orders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _ctrl.orders.length,
        itemBuilder: (_, i) {
          final order = _ctrl.orders[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                  child: Icon(Icons.receipt_outlined)),
              title: Text('Đơn #${order.id.substring(0, 8)}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.statusDisplay),
                  Text(FormatUtils.formatDate(order.createdAt)),
                ],
              ),
              trailing: Text(
                FormatUtils.formatPrice(order.totalAmount),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              onTap: () =>
                  Get.toNamed('/order-detail', arguments: order.id),
            ),
          );
        },
      )),
    );
  }
}