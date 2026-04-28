import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../../common/constants/app_colors.dart';
import '../../common/widgets/product_card.dart';
import '../../controller/product_controller.dart';
import '../../controller/cart_controller.dart';
import '../../controller/auth_controller.dart';
import '../../controller/notification_controller.dart';
import '../../routes/app_routes.dart';
import '../cart/cart_screen.dart';
import '../mystore/search_screen.dart';
import '../mystore/store_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = [
    const _HomePage(),
    const _StorePage(),
    const _WishlistPage(),
    const _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    final notifCtrl = Get.find<NotificationController>();

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Cửa hàng'),
          BottomNavigationBarItem(
            icon: badges.Badge(
              showBadge: cartCtrl.totalItems > 0,
              badgeContent: Text('${cartCtrl.totalItems}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10)),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: badges.Badge(
              showBadge: cartCtrl.totalItems > 0,
              badgeContent: Text('${cartCtrl.totalItems}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10)),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Giỏ hàng',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Cá nhân'),
        ],
      )),
    );
  }
}

// ── Trang chủ ──
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    final authCtrl = Get.find<AuthController>();
    final cartCtrl = Get.find<CartController>();
    final notifCtrl = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BookShop',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Obx(() => Text(
              'Xin chào, ${authCtrl.currentUser.value?.fullName ?? 'Bạn'}!',
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12),
            )),
          ],
        ),
        actions: [
          Obx(() => IconButton(
            icon: badges.Badge(
              showBadge: notifCtrl.unreadCount > 0,
              badgeContent: Text('${notifCtrl.unreadCount}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10)),
              child: const Icon(Icons.notifications_outlined,
                  color: Colors.white),
            ),
            onPressed: () =>
                Get.toNamed(AppRoutes.notifications),
          )),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => Get.toNamed(AppRoutes.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await productCtrl.loadFeatured();
          await productCtrl.loadProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Container(
                margin: const EdgeInsets.all(16),
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sách hay\nmỗi ngày',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3)),
                            SizedBox(height: 8),
                            Text('Giảm đến 30%',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.menu_book_rounded,
                          size: 80, color: Colors.white24),
                    ),
                  ],
                ),
              ),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Danh mục',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.store),
                      child: const Text('Xem tất cả',
                          style: TextStyle(
                              color: AppColors.primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: productCtrl.categories.length,
                  itemBuilder: (_, i) {
                    final cat = productCtrl.categories[i];
                    final icons = [
                      Icons.all_inclusive,
                      Icons.psychology_outlined,
                      Icons.auto_stories_outlined,
                      Icons.school_outlined,
                      Icons.science_outlined,
                      Icons.edit_outlined,
                    ];
                    return GestureDetector(
                      onTap: () {
                        productCtrl.selectCategory(cat);
                        Get.toNamed(AppRoutes.store);
                      },
                      child: Container(
                        width: 72,
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 52, height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icons[i % icons.length],
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(cat,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),

              const SizedBox(height: 20),

              // Featured
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Nổi bật',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Obx(() => productCtrl.featured.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Chưa có sản phẩm'),
                ),
              )
                  : SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  itemCount: productCtrl.featured.length,
                  itemBuilder: (_, i) => SizedBox(
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ProductCard(
                          product: productCtrl.featured[i]),
                    ),
                  ),
                ),
              )),

              const SizedBox(height: 20),

              // Seed button (dev only)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () => productCtrl.seedData(),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Thêm dữ liệu mẫu (Dev)'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Store page (tab) ──
class _StorePage extends StatelessWidget {
  const _StorePage();

  @override
  Widget build(BuildContext context) {
    return const StoreScreenInTab();
  }
}

// ── Wishlist page (tab) ──
class _WishlistPage extends StatelessWidget {
  const _WishlistPage();

  @override
  Widget build(BuildContext context) {
    return const CartScreenInTab();
  }
}

// ── Profile page (tab) ──
class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const ProfileScreenInTab();
  }
}