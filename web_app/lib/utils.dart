import 'package:hive/hive.dart';
import 'new_diary_page.dart';


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

class DiaryDataUtils {
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

  static Future<void> deleteNote(String key) async {
    if(_box.keys.contains(key)) {
      await _box.delete(key);
    }
  }

  static Future<List<Note>> getAllNotes() async {
    Map<String, String> allData = {};
    List<Note> pastData = [];

    var boxMap = await _box.toMap();
    boxMap.forEach((key, value) {
      allData[key.toString()] = value.toString();
    });

    for(String key in allData.keys) {
      String title = allData[key]!.split('////')[0];
      String description = allData[key]!.split('////')[1];
      pastData.add(Note(
        title: title,
        description: description,
        notedate: CycleDataUtils.stringToDate(key)
      ));
    }
    return pastData;
  }
}
