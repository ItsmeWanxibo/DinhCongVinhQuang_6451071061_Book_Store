import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../controller/auth_controller.dart';
import '../../data/models/review_model.dart';
import '../../data/services/product_service.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final String productId = Get.arguments as String;
  double _rating = 5;
  final _commentCtrl = TextEditingController();
  bool _isLoading = false;
  final _authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Viết đánh giá')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Đánh giá của bạn:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                itemBuilder: (_, __) =>
                const Icon(Icons.star, color: AppColors.star),
                onRatingUpdate: (r) => setState(() => _rating = r),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Nhận xét của bạn về sản phẩm...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Gửi đánh giá',
              isLoading: _isLoading,
              onPressed: () async {
                if (_commentCtrl.text.trim().isEmpty) return;
                setState(() => _isLoading = true);
                final user = _authCtrl.currentUser.value!;
                final review = ReviewModel(
                  id: '',
                  userId: user.uid,
                  userName: user.fullName,
                  productId: productId,
                  rating: _rating,
                  comment: _commentCtrl.text.trim(),
                );
                await ProductService().addReview(review);
                setState(() => _isLoading = false);
                Get.back();
                Get.snackbar('Thành công', 'Cảm ơn bạn đã đánh giá!',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ],
        ),
      ),
    );
  }
}