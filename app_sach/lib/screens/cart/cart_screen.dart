import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/cart_controller.dart';
import '../../utils/format_utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => const CartScreenInTab();
}

class CartScreenInTab extends StatelessWidget {
  const CartScreenInTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Obx(() => ctrl.items.isEmpty
          ? const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Giỏ hàng trống',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: ctrl.items.length,
              itemBuilder: (_, i) {
                final item = ctrl.items[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 60, height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.shimmer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.book,
                              color: AppColors.textHint),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              if (item.variant.isNotEmpty)
                                Text(item.variant,
                                    style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12)),
                              const SizedBox(height: 8),
                              Text(
                                FormatUtils.formatPrice(item.price),
                                style: const TextStyle(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline),
                                    onPressed: () => ctrl.updateQuantity(
                                        item.productId,
                                        item.quantity - 1),
                                    iconSize: 20,
                                    color: AppColors.primary,
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.add_circle_outline),
                                    onPressed: () => ctrl.updateQuantity(
                                        item.productId,
                                        item.quantity + 1),
                                    iconSize: 20,
                                    color: AppColors.primary,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () => ctrl.removeItem(
                                        item.productId),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -2))
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng cộng:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(FormatUtils.formatPrice(ctrl.totalPrice),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error)),
                  ],
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Thanh toán',
                  onPressed: () => Get.toNamed('/checkout'),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}