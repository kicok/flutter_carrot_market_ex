import 'package:intl/intl.dart';

class DataUtils {
  static String calcStringToWon(String priceString) {
    final oCcy = NumberFormat();
    if (priceString == '무료나눔') return priceString;
    return oCcy.format(int.parse(priceString)) + "원";
  }

  static String stringChange(dynamic str) {
    if (str == null) return "";
    return str.toString();
  }
}
