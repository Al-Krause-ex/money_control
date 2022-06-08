import 'package:intl/intl.dart';

class StringHelper {
  static String getSeparatedDigits(int digit) {
    var formatter = NumberFormat('#,###');
    return formatter.format(digit.toInt()).replaceAll(',', ' ');
  }
}