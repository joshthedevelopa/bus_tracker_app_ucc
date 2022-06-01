import '../imports.dart';

class Storage {
  static SharedPreferences? _storage;

  static Future<SharedPreferences> instance() async {
    _storage = _storage ??= await SharedPreferences.getInstance();
    return _storage!;
  }

  static Future<bool> set(String key, String value) async {
    _storage = await instance();
    return await _storage!.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    _storage = await instance();
    return await _storage!.setBool(key, value);
  }

  static Future<dynamic> get(String key) async {
    _storage = await instance();
    return _storage!.get(key);
  }

  static Future<bool> clear([String? key]) async {
    _storage = await instance();
    if(key != null) {
      return await _storage!.remove(key);
    }
    return await _storage!.clear();
  }
}
