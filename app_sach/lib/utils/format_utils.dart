import 'package:intl/intl.dart';

class FormatUtils {
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price)}đ';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatDateOnly(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}