import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  final _pages = [
    _OnboardingData(
      icon: Icons.library_books_outlined,
      title: 'Kho sách phong phú',
      desc: 'Hàng nghìn đầu sách từ các thể loại khác nhau, cập nhật liên tục mỗi ngày.',
      color: const Color(0xFF4299E1),
    ),
    _OnboardingData(
      icon: Icons.shopping_cart_outlined,
      title: 'Mua sắm dễ dàng',
      desc: 'Tìm kiếm, lọc và đặt hàng chỉ với vài thao tác đơn giản.',
      color: const Color(0xFF48BB78),
    ),
    _OnboardingData(
      icon: Icons.local_shipping_outlined,
      title: 'Giao hàng nhanh chóng',
      desc: 'Nhận sách tận nhà, theo dõi đơn hàng theo thời gian thực.',
      color: const Color(0xFFED8936),
    ),
  ];

  Future<void> _done() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    Get.offNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _done,
                child: const Text('Bỏ qua',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final data = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: data.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(data.icon,
                              size: 80, color: data.color),
                        ),
                        const SizedBox(height: 40),
                        Text(data.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 16),
                        Text(data.desc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                height: 1.6)),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator
            SmoothPageIndicator(
              controller: _ctrl,
              count: _pages.length,
              effect: WormEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.border,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),

            const SizedBox(height: 32),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AppButton(
                text: _page == _pages.length - 1 ? 'Bắt đầu' : 'Tiếp theo',
                onPressed: () {
                  if (_page == _pages.length - 1) {
                    _done();
                  } else {
                    _ctrl.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _OnboardingData(
      {required this.icon,
        required this.title,
        required this.desc,
        required this.color});
}