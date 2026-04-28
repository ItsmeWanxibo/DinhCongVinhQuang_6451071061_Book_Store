import 'package:get/get.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/services/cart_service.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final CartService _service = CartService();
  final AuthController _authCtrl = Get.find();

  final RxList<CartItemModel> items = <CartItemModel>[].obs;
  final RxBool isLoading = false.obs;

  String? get uid => _authCtrl.currentUser.value?.uid;

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice => items.fold(0, (sum, i) => sum + i.subtotal);

  @override
  void onInit() {
    super.onInit();
    ever(_authCtrl.currentUser, (_) => loadCart());
  }

  Future<void> loadCart() async {
    if (uid == null) { items.clear(); return; }
    isLoading.value = true;
    items.value = await _service.getCart(uid!);
    isLoading.value = false;
  }

  Future<void> addToCart(ProductModel product, {
    int quantity = 1,
    String variant = '',
  }) async {
    if (uid == null) { Get.toNamed('/login'); return; }
    final item = CartItemModel(
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: quantity,
      variant: variant,
      image: product.firstImage,
    );
    await _service.addToCart(uid!, item);
    await loadCart();
    Get.snackbar('Đã thêm', '${product.name} đã thêm vào giỏ hàng',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> updateQuantity(String productId, int qty) async {
    if (uid == null) return;
    await _service.updateQuantity(uid!, productId, qty);
    await loadCart();
  }

  Future<void> removeItem(String productId) async {
    if (uid == null) return;
    await _service.removeFromCart(uid!, productId);
    await loadCart();
  }

  Future<void> clearCart() async {
    if (uid == null) return;
    await _service.clearCart(uid!);
    items.clear();
  }
}