import 'package:hive/hive.dart';

class CycleDataUtils {
  static Box<String> get _box => Hive.box<String>('cycleData');

  static Future<void> writeCycleData(String key, String value) async {
    await _box.put(key, value);
  }

  static String? readCycleData(String key) {
    return _box.get(key);
  }

  static String dateToString(DateTime date) {
    String year = date.year.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static DateTime stringToDate(String date) {
    return DateTime.parse(date);
  }

  static String generateEntry(int cycleLength, DateTime cycleStartDate, DateTime entryDate) {
    return '${cycleLength.toString()} ${dateToString(cycleStartDate)} ${dateToString(entryDate)}';
  }

  static List<dynamic> separateEntry(String entry) {
    List<String> separated = entry.split(' ');
    int cycleLength = int.parse(separated[0]);
    String cycleStartDate = separated[1];
    String entryDate = separated[2];
    return [cycleLength, cycleStartDate, entryDate];
  }

  static Future<void> deleteLastEntry() async {
    if (_box.isNotEmpty) {
        var lastKey = _box.keys.last;
        await _box.delete(lastKey);
    }
  }

  static Map<String, String?> readAllCycleData() {
    Map<String, String?> allData = {};
    for (var key in _box.keys) {
        // Keep the value as nullable
        allData[key] = _box.get(key);
    }
    return allData;
  }

}
