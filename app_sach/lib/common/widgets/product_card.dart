import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product_model.dart';
import '../../controller/wishlist_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/format_utils.dart';
import '../constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishCtrl = Get.find<WishlistController>();

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetail, arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: product.firstImage,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 160,
                      color: AppColors.shimmer,
                      child: const Center(
                          child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 160,
                      color: AppColors.shimmer,
                      child: const Icon(Icons.book, size: 48,
                          color: AppColors.textHint),
                    ),
                  ),
                ),

                // Discount badge
                if (product.hasDiscount)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${product.discountPercent.round()}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                // Wishlist button
                Positioned(
                  top: 6, right: 6,
                  child: Obx(() => GestureDetector(
                    onTap: () => wishCtrl.toggle(product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        wishCtrl.isWishlisted(product.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wishCtrl.isWishlisted(product.id)
                            ? Colors.red
                            : Colors.grey,
                        size: 18,
                      ),
                    ),
                  )),
                ),
              ],
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textPrimary)),
                  if (product.author.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(product.author,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.star, size: 12),
                      const SizedBox(width: 2),
                      Text('${product.rating}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(width: 4),
                      Text('(${product.reviewCount})',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(FormatUtils.formatPrice(product.price),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.error)),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatPrice(product.originalPrice),
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textHint,
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}