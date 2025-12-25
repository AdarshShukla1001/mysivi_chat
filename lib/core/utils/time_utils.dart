import 'package:intl/intl.dart';

class TimeUtils {
  static String formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat.Hm().format(dateTime); // e.g., 14:30
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(dateTime); // e.g., Mon
    } else {
      return DateFormat.yMd().format(dateTime); // e.g., 12/25/2025
    }
  }
}
