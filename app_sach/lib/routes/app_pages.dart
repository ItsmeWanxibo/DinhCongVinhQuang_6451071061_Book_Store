import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/product_binding.dart';
import '../bindings/cart_binding.dart';
import '../bindings/order_binding.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/mystore/store_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/order/checkout_screen.dart';
import '../screens/order/order_list_screen.dart';
import '../screens/order/order_detail_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/shipping_address/shipping_address_screen.dart';
import '../screens/shipping_address/add_address_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/review/review_screen.dart';
import '../screens/mystore/search_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.store,
      page: () => const StoreScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.orderList,
      page: () => const OrderListScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.shippingAddress,
      page: () => const ShippingAddressScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.addAddress,
      page: () => const AddAddressScreen(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.review,
      page: () => const ReviewScreen(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: ProductBinding(),
    ),
  ];
}