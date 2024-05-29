import 'package:localstorage/localstorage.dart';

class StorageManager {
  static final LocalStorage storage = LocalStorage('my_app_data.json');

  static Future<void> initLocalStorage() async {
    await storage.ready;
  }

  static Future<void> saveData(String key, String value) async {
    await storage.setItem(key, value);
  }

  static String? loadData(String key) {
    return storage.getItem(key);
  }
}
