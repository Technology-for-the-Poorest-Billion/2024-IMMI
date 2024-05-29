import 'package:hive/hive.dart';

class StorageUtil {
  static Box<String> get _box => Hive.box<String>('diaryBox'); // Ensure Box<String> is used

  static Future<void> writeData(String key, String value) async {
    try {
      await _box.put(key, value);
      print('Data saved');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  static String? readData(String key) {
    try {
      var data = _box.get(key);
      print('Read data: $data');
      return data;
    } catch (e) {
      print('Error reading data: $e');
      return null;
    }
  }

  static Map<String, String> getAllEntries() {
    return Map.fromEntries(
      _box.keys.cast<String>().map((key) => MapEntry(key, _box.get(key) ?? "No entry found"))
    );
  }
}