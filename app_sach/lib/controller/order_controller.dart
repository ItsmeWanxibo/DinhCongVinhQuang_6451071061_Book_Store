import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/services/order_service.dart';
import '../data/services/address_service.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';
import '../routes/app_routes.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final AddressService _addressService = AddressService();
  final AuthController _authCtrl = Get.find();
  final CartController _cartCtrl = Get.find();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);
  final RxString paymentMethod = 'COD'.obs;
  final RxBool isLoading = false.obs;

  String? get uid => _authCtrl.currentUser.value?.uid;

  Future<void> loadOrders() async {
    if (uid == null) return;
    isLoading.value = true;
    orders.value = await _orderService.getUserOrders(uid!);
    isLoading.value = false;
  }

  Future<void> loadAddresses() async {
    if (uid == null) return;
    addresses.value = await _addressService.getAddresses(uid!);
    if (addresses.isNotEmpty) selectedAddress.value = addresses.first;
  }

  Future<void> addAddress(AddressModel address) async {
    if (uid == null) return;
    await _addressService.addAddress(uid!, address);
    await loadAddresses();
  }

  Future<void> placeOrder() async {
    if (uid == null || selectedAddress.value == null) return;
    if (_cartCtrl.items.isEmpty) {
      Get.snackbar('Lỗi', 'Giỏ hàng trống');
      return;
    }

    try {
      isLoading.value = true;
      final order = OrderModel(
        id: '',
        userId: uid!,
        items: List.from(_cartCtrl.items),
        shippingAddress: selectedAddress.value!,
        totalAmount: _cartCtrl.totalPrice,
        paymentMethod: paymentMethod.value,
      );
      final orderId = await _orderService.createOrder(order);
      await _cartCtrl.clearCart();

      Get.offAllNamed(AppRoutes.orderDetail, arguments: orderId);
      Get.snackbar('Đặt hàng thành công', 'Đơn hàng của bạn đã được xác nhận!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await _orderService.cancelOrder(orderId);
    await loadOrders();
    Get.snackbar('Đã hủy', 'Đơn hàng đã được hủy',
        snackPosition: SnackPosition.BOTTOM);
  }
}