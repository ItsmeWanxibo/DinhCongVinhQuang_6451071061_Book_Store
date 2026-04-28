import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/order_controller.dart';
import '../../data/services/order_service.dart';
import '../../data/models/order_model.dart';
import '../../utils/format_utils.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? _order;
  final _ctrl = Get.find<OrderController>();
  final String orderId = Get.arguments as String;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final order = await OrderService().getOrder(orderId);
    setState(() => _order = order);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'shipping': return Colors.purple;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_order == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _statusColor(_order!.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: _statusColor(_order!.status).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.local_shipping_outlined,
                      color: _statusColor(_order!.status), size: 40),
                  const SizedBox(height: 8),
                  Text(_order!.statusDisplay,
                      style: TextStyle(
                          color: _statusColor(_order!.status),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items
            const Text('Sản phẩm đã đặt',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ..._order!.items.map((item) => ListTile(
              leading: const Icon(Icons.book),
              title: Text(item.name),
              subtitle: Text(
                  '${item.variant.isNotEmpty ? item.variant + ' · ' : ''}SL: ${item.quantity}'),
              trailing: Text(
                FormatUtils.formatPrice(item.subtotal),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )),

            const Divider(),

            // Address
            const Text('Địa chỉ giao hàng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Text(_order!.shippingAddress.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(_order!.shippingAddress.phone),
            Text(_order!.shippingAddress.fullAddress),
            const Divider(),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng tiền:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(FormatUtils.formatPrice(_order!.totalAmount),
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),

            if (_order!.status == 'pending')
              AppButton(
                text: 'Hủy đơn hàng',
                color: Colors.red,
                onPressed: () => _ctrl.cancelOrder(_order!.id),
              ),
          ],
        ),
      ),
    );
  }
}