import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/product_card.dart';
import '../../controller/wishlist_controller.dart';
import '../../controller/product_controller.dart';
import '../../data/models/product_model.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishCtrl = Get.find<WishlistController>();
    final productCtrl = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Yêu thích')),
      body: Obx(() {
        final wishIds = wishCtrl.wishlistIds;
        if (wishIds.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('Chưa có sản phẩm yêu thích',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        }

        final wishedProducts = productCtrl.products
            .where((p) => wishIds.contains(p.id))
            .toList();

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: wishedProducts.length,
          itemBuilder: (_, i) => ProductCard(product: wishedProducts[i]),
        );
      }),
    );
  }
}