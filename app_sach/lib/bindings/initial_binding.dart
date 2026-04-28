import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/cart_controller.dart';
import '../controller/wishlist_controller.dart';
import '../controller/notification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
  }
}