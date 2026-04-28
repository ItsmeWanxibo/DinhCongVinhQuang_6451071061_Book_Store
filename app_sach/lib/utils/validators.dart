class Validators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập email';
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$').hasMatch(v.trim()))
      return 'Email không hợp lệ';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Nhập mật khẩu';
    if (v.length < 6) return 'Mật khẩu phải từ 6 ký tự';
    return null;
  }

  static String? required(String? v, [String field = 'Trường này']) {
    if (v == null || v.trim().isEmpty) return '$field không được để trống';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập số điện thoại';
    if (!RegExp(r'^[0-9]{9,11}$').hasMatch(v.trim()))
      return 'SĐT không hợp lệ';
    return null;
  }
}