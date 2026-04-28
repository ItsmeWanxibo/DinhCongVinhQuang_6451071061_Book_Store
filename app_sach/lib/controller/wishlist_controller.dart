import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/wishlist_service.dart';
import '../data/services/product_service.dart';
import 'auth_controller.dart';

class WishlistController extends GetxController {
  final WishlistService _service = WishlistService();
  final ProductService _productService = ProductService();
  final AuthController _authCtrl = Get.find();

  final RxList<String> wishlistIds = <String>[].obs;
  final RxList<ProductModel> wishlistProducts = <ProductModel>[].obs;

  String? get uid => _authCtrl.currentUser.value?.uid;

  @override
  void onInit() {
    super.onInit();
    ever(_authCtrl.currentUser, (_) => loadWishlist());
  }

  Future<void> loadWishlist() async {
    if (uid == null) { wishlistIds.clear(); return; }
    wishlistIds.value = await _service.getWishlist(uid!);
  }

  bool isWishlisted(String productId) => wishlistIds.contains(productId);

  Future<void> toggle(ProductModel product) async {
    if (uid == null) { Get.toNamed('/login'); return; }
    if (isWishlisted(product.id)) {
      await _service.removeFromWishlist(uid!, product.id);
      wishlistIds.remove(product.id);
      Get.snackbar('Đã xóa', '${product.name} đã xóa khỏi yêu thích',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      await _service.addToWishlist(uid!, product.id);
      wishlistIds.add(product.id);
      Get.snackbar('Đã thêm', '${product.name} đã thêm vào yêu thích',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}