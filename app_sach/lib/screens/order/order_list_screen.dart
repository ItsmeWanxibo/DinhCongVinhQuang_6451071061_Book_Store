import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
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
    // Load ngay khi mở màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.loadOrders();
    });
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

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending': return Icons.access_time;
      case 'confirmed': return Icons.check_circle_outline;
      case 'shipping': return Icons.local_shipping_outlined;
      case 'delivered': return Icons.done_all;
      case 'cancelled': return Icons.cancel_outlined;
      default: return Icons.receipt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _ctrl.loadOrders,
          ),
        ],
      ),
      body: Obx(() {
        if (_ctrl.isLoadingOrders.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_ctrl.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Chưa có đơn hàng nào',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  child: const Text('Mua sắm ngay'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _ctrl.loadOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _ctrl.orders.length,
            itemBuilder: (_, i) {
              final order = _ctrl.orders[i];
              final color = _statusColor(order.status);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: InkWell(
                  onTap: () => Get.toNamed('/order-detail',
                      arguments: order.id),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_statusIcon(order.status),
                                  color: color, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đơn #${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    FormatUtils.formatDate(
                                        order.createdAt),
                                    style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: color.withOpacity(0.3)),
                              ),
                              child: Text(
                                order.statusDisplay,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),

                        // Items preview
                        ...order.items.take(2).map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.book_outlined,
                                  size: 14,
                                  color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text('x${item.quantity}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color:
                                      AppColors.textSecondary)),
                            ],
                          ),
                        )),

                        if (order.items.length > 2)
                          Text(
                            '+ ${order.items.length - 2} sản phẩm khác',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order.items.length} sản phẩm',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12),
                            ),
                            Text(
                              FormatUtils.formatPrice(order.totalAmount),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}