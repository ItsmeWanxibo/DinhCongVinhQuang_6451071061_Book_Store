import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
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
  final _ctrl = Get.find<OrderController>();
  final OrderService _orderService = OrderService();
  OrderModel? _order;
  bool _isLoading = true;
  String? _error;

  late final String orderId;

  @override
  void initState() {
    super.initState();
    orderId = Get.arguments as String;
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final order = await _orderService.getOrder(orderId);
      setState(() {
        _order = order;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: const Text('Bạn có chắc muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        setState(() => _isLoading = true);
        await _orderService.updateStatus(orderId, 'cancelled');
        await _ctrl.loadOrders();
        await _loadOrder(); // Reload để cập nhật UI
        Get.snackbar('Thành công', 'Đơn hàng đã được hủy',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } catch (e) {
        setState(() => _isLoading = false);
        Get.snackbar('Lỗi', 'Không thể hủy đơn: $e',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 12),
              Text(_error ?? 'Không tìm thấy đơn hàng'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadOrder,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final order = _order!;
    final statusColor = _statusColor(order.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
            'Đơn #${orderId.length > 8 ? orderId.substring(0, 8).toUpperCase() : orderId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadOrder,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(_statusIcon(order.status),
                      color: statusColor, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    order.statusDisplay,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    FormatUtils.formatDate(order.createdAt),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sản phẩm
            _sectionCard(
              title: 'Sản phẩm đã đặt',
              icon: Icons.shopping_bag_outlined,
              child: Column(
                children: order.items
                    .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.shimmer,
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.book,
                            color: AppColors.textHint),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 13)),
                            if (item.variant.isNotEmpty)
                              Text(item.variant,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors
                                          .textSecondary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Text('x${item.quantity}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                          Text(
                            FormatUtils.formatPrice(
                                item.subtotal),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Địa chỉ
            _sectionCard(
              title: 'Địa chỉ giao hàng',
              icon: Icons.location_on_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.shippingAddress.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(order.shippingAddress.phone,
                      style: const TextStyle(
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text(order.shippingAddress.fullAddress,
                      style: const TextStyle(
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Thanh toán
            _sectionCard(
              title: 'Thông tin thanh toán',
              icon: Icons.payment_outlined,
              child: Column(
                children: [
                  _infoRow('Phương thức:',
                      order.paymentMethod == 'COD'
                          ? 'Thanh toán khi nhận hàng'
                          : 'Chuyển khoản'),
                  const Divider(height: 12),
                  _infoRow('Tổng tiền hàng:',
                      FormatUtils.formatPrice(order.totalAmount)),
                  _infoRow('Phí vận chuyển:', 'Miễn phí',
                      valueColor: AppColors.success),
                  const Divider(height: 12),
                  _infoRow(
                    'Tổng thanh toán:',
                    FormatUtils.formatPrice(order.totalAmount),
                    bold: true,
                    valueColor: AppColors.error,
                    valueFontSize: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            if (order.status == 'pending') ...[
              Obx(() => AppButton(
                text: 'Hủy đơn hàng',
                color: Colors.red,
                isLoading: _ctrl.isLoading.value,
                onPressed: _cancelOrder,
              )),
              const SizedBox(height: 12),
            ],

            if (order.status == 'delivered')
              AppButton(
                text: 'Đánh giá sản phẩm',
                outlined: true,
                onPressed: () => Get.toNamed('/review',
                    arguments: order.items.first.productId),
              ),

            AppButton(
              text: 'Về trang chủ',
              outlined: order.status != 'delivered',
              onPressed: () => Get.offAllNamed('/home'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const Divider(height: 16),
            child,
          ],
        ),
      );

  Widget _infoRow(
      String label,
      String value, {
        bool bold = false,
        Color? valueColor,
        double valueFontSize = 14,
      }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? AppColors.textPrimary,
                fontSize: valueFontSize,
              ),
            ),
          ],
        ),
      );
}