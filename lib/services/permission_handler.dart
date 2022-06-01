import '../imports.dart';

class PermissionHandler {
  static Future<bool> checkPositionService() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    return [
      LocationPermission.always,
      LocationPermission.whileInUse,
    ].contains(permission);
  }
}
