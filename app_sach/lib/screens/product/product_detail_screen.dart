import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/cart_controller.dart';
import '../../controller/wishlist_controller.dart';
import '../../data/models/product_model.dart';
import '../../utils/format_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductModel product = Get.arguments as ProductModel;
  String _selectedVariant = '';
  int _quantity = 1;
  final CartController _cartCtrl = Get.find();
  final WishlistController _wishCtrl = Get.find();

  @override
  void initState() {
    super.initState();
    if (product.variants.isNotEmpty) {
      _selectedVariant = product.variants.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              Obx(() => IconButton(
                icon: Icon(
                  _wishCtrl.isWishlisted(product.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () => _wishCtrl.toggle(product),
              )),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.firstImage,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.shimmer,
                  child: const Icon(Icons.book, size: 80,
                      color: AppColors.textHint),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(product.category,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),

                  // Name
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  if (product.author.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Tác giả: ${product.author}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14)),
                  ],
                  const SizedBox(height: 12),

                  // Rating
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: AppColors.star),
                        itemCount: 5,
                        itemSize: 18,
                      ),
                      const SizedBox(width: 8),
                      Text('${product.rating} (${product.reviewCount} đánh giá)',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      Text(FormatUtils.formatPrice(product.price),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error)),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 10),
                        Text(FormatUtils.formatPrice(product.originalPrice),
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textHint,
                                decoration: TextDecoration.lineThrough)),
                        const SizedBox(width: 8),
                        Container(
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
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Variants
                  if (product.variants.isNotEmpty) ...[
                    const Text('Phiên bản:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: product.variants.map((v) {
                        final selected = _selectedVariant == v;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedVariant = v),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(v,
                                style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Quantity
                  Row(
                    children: [
                      const Text('Số lượng:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_quantity > 1)
                                setState(() => _quantity--);
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                          ),
                          Text('$_quantity',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => _quantity++),
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text('Còn ${product.stock} sản phẩm',
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text('Mô tả sản phẩm',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.6,
                          fontSize: 14)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Thêm vào giỏ',
                outlined: true,
                onPressed: () => _cartCtrl.addToCart(
                  product,
                  quantity: _quantity,
                  variant: _selectedVariant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Mua ngay',
                onPressed: () {
                  _cartCtrl.addToCart(
                    product,
                    quantity: _quantity,
                    variant: _selectedVariant,
                  );
                  Get.toNamed('/cart');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}