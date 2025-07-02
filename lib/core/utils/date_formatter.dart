import 'package:intl/intl.dart';

class DateFormatter {
  static String formatNewsDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  static String getTimeAgo(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final Duration difference = DateTime.now().difference(dateTime);

      if (difference.inDays >= 365) {
        return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
      } else if (difference.inDays >= 30) {
        return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }
}
