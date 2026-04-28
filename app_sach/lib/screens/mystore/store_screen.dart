import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/product_card.dart';
import '../../controller/product_controller.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoreScreenInTab();
  }
}

class StoreScreenInTab extends StatelessWidget {
  const StoreScreenInTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cửa hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => Get.toNamed('/search'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories filter
          Obx(() => SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              itemCount: ctrl.categories.length,
              itemBuilder: (_, i) {
                final cat = ctrl.categories[i];
                final selected = ctrl.selectedCategory.value == cat;
                return GestureDetector(
                  onTap: () => ctrl.selectCategory(cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(cat,
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ),
                );
              },
            ),
          )),

          // Products grid
          Expanded(
            child: Obx(() => ctrl.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ctrl.products.isEmpty
                ? const Center(child: Text('Không có sản phẩm'))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: ctrl.products.length,
              itemBuilder: (_, i) =>
                  ProductCard(product: ctrl.products[i]),
            )),
          ),
        ],
      ),
    );
  }
}