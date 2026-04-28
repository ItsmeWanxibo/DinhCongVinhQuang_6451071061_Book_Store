import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? user) async {
    if (user != null) {
      currentUser.value = await _authService.getUser(user.uid);
    } else {
      currentUser.value = null;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      isLoading.value = true;
      final user = await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Lỗi', _authError(e.code),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final user = await _authService.login(email: email, password: password);
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Lỗi', _authError(e.code),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      await _authService.forgotPassword(email);
      Get.snackbar('Thành công', 'Email đặt lại mật khẩu đã được gửi',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UserModel user) async {
    try {
      isLoading.value = true;
      await _authService.updateUser(user);
      currentUser.value = user;
      Get.snackbar('Thành công', 'Cập nhật hồ sơ thành công',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'email-already-in-use': return 'Email đã được sử dụng';
      case 'invalid-email': return 'Email không hợp lệ';
      case 'weak-password': return 'Mật khẩu quá yếu';
      case 'user-not-found': return 'Tài khoản không tồn tại';
      case 'wrong-password': return 'Mật khẩu không đúng';
      default: return 'Có lỗi xảy ra';
    }
  }
}