import 'package:intl/intl.dart';

class GlobalMethods {
  static String formattedDate(String publishedAt) {
    final parsedDate = DateTime.parse(publishedAt);
    final formatter = DateFormat('yyyy/MM/dd \'ON\' HH:mm');
    return formatter.format(parsedDate);
  }
}
