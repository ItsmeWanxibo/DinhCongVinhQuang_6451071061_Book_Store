import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/constants/app_colors.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: _animCtrl, curve: Curves.easeIn));
    _scaleAnim =
        Tween<double>(begin: 0.5, end: 1).animate(CurvedAnimation(
            parent: _animCtrl, curve: Curves.elasticOut));
    _animCtrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboarded') ?? false;
    final user = FirebaseAuth.instance.currentUser;

    if (!onboarded) {
      Get.offNamed(AppRoutes.onboarding);
    } else if (user != null) {
      Get.offNamed(AppRoutes.home);
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animCtrl,
          builder: (_, __) => FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        size: 56, color: AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  const Text('BookShop',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  const SizedBox(height: 8),
                  const Text('Sách & Văn phòng phẩm',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}