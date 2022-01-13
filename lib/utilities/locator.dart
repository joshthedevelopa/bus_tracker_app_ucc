import '../imports.dart';

class Locator {
  static Future<Position> getPosition() async {
    return await Geolocator.getCurrentPosition();
  }
}