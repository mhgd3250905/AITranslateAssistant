import 'package:get_storage/get_storage.dart';

class GSIntance {
  String TAG = "GSIntance";

  static final _instance = GSIntance._();

  factory GSIntance.getInstance() => _instance;

  GSIntance._();

  static String API_KEY = 'api_key';
  static String KEY_DESC_MAP = 'key_desc_map';
  static String KEY_SPECIAL_MAP = 'key_special_map';

  static String KEY_DESC_ENABLE = 'key_desc_enable';
  static String KEY_SPECIAL_ENABLE = 'key_special_enable';

  void init() async {
    await GetStorage.init();
  }

  Future<void> setString(String k, String v) {
    final box = GetStorage();
    return box.write(k, v);
  }

  String getString(String k) {
    final box = GetStorage();
    var result = box.read<String>(k);
    if (result == null) {
      return '';
    }
    return result;
  }

  Future<void> setBool(String k, bool v) {
    final box = GetStorage();
    return box.write(k, v);
  }

  bool getBool(String k) {
    final box = GetStorage();
    var result = box.read<bool>(k);
    if (result == null) {
      return false;
    }
    return result;
  }

  Future<void> remove(String k) {
    final box = GetStorage();
    return box.remove(k);
  }
}
