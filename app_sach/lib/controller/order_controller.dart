import 'package:get/get.dart';
import '../data/models/order_model.dart';
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
  final RxString paymentMethod = 'COD'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingOrders = false.obs;

  String? get uid => _authCtrl.currentUser.value?.uid;

  Future<void> loadOrders() async {
    if (uid == null) {
      orders.clear();
      return;
    }
    try {
      isLoadingOrders.value = true;
      final result = await _orderService.getUserOrders(uid!);
      orders.assignAll(result);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải đơn hàng: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingOrders.value = false;
    }
  }

  Future<void> loadAddresses() async {
    if (uid == null) return;
    try {
      final result = await _addressService.getAddresses(uid!);
      addresses.assignAll(result);
      if (result.isNotEmpty && selectedAddress.value == null) {
        selectedAddress.value = result.first;
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> addAddress(AddressModel address) async {
    if (uid == null) return;
    await _addressService.addAddress(uid!, address);
    await loadAddresses();
    Get.snackbar('Thành công', 'Đã thêm địa chỉ',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> deleteAddress(String addressId) async {
    if (uid == null) return;
    await _addressService.deleteAddress(uid!, addressId);
    await loadAddresses();
  }

  Future<void> placeOrder() async {
    if (uid == null || selectedAddress.value == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn địa chỉ giao hàng',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_cartCtrl.items.isEmpty) {
      Get.snackbar('Lỗi', 'Giỏ hàng trống',
          snackPosition: SnackPosition.BOTTOM);
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

      // Load lại danh sách đơn hàng
      await loadOrders();

      Get.offAllNamed(AppRoutes.orderDetail, arguments: orderId);
      Get.snackbar(
        'Đặt hàng thành công!',
        'Đơn hàng của bạn đã được xác nhận.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể đặt hàng: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      await _orderService.updateStatus(orderId, 'cancelled');
      await loadOrders();
      Get.back();
      Get.snackbar('Đã hủy', 'Đơn hàng đã được hủy thành công',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể hủy đơn: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}