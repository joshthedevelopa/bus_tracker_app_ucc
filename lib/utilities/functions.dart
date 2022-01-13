
class Utils {
  static String hourConvertor(int seconds) {
    double _tmp = seconds / 3600;
    return _tmp.toStringAsFixed(2);
  }

  static String kmConvertor(int meters) {
    double _tmp = meters / 1000;
    return _tmp.toStringAsFixed(2);
  }
}