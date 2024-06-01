import 'package:hive/hive.dart';
import 'new_diary_page.dart';
import 'data_page.dart';


class CycleData {
  List<int> cycleLengths;
  List<String> startDates;
  List<String> entryDates;

  CycleData(this.cycleLengths, this.startDates, this.entryDates);
}

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

  static Future<void> deleteAllEntry() async {
    await _box.clear();
  }

  static Future<Map<String, String>> readAllCycleData() async {
    Map<String, String> allData = {};
    // Ensure _box is awaited if it's a future or requires async operation to initialize
    var boxMap = await _box.toMap();  // Make sure to await if necessary, depends on your Hive setup
    boxMap.forEach((key, value) {
        allData[key.toString()] = value.toString(); // Ensuring the value is also a string
    });
    return allData;
  }

  static Future<List<TableCycleData>> getAllCycleData() async {
    Map<String, String> allData = {};
    List<TableCycleData> pastData = [];

    // Ensure _box is awaited if it's a future or requires async operation to initialize
    var boxMap = await _box.toMap();  // Make sure to await if necessary, depends on your Hive setup
    boxMap.forEach((key, value) {
        allData[key.toString()] = value.toString(); // Ensuring the value is also a string
    });

    for(String key in allData.keys) {
      String cycleLength = allData[key]!.split(' ')[0];
      String cycleStartDate = allData[key]!.split(' ')[1];
      pastData.add(TableCycleData(
        entryDate: key,
        cycleStartDate: cycleStartDate,
        cycleLength: cycleLength
      ));
    }
    return pastData;
  }

  static Future<CycleData> loadData() async {
    // Load all past data
    Map<String, String> allData = await readAllCycleData();
    List<int> pastCycleLengths = [];
    List<String> pastCycleStartDates = [];
    List<String> pastEntryDates = [];

    // Iterate over all entries
    for (var entry in allData.entries) {
        String entryKey = entry.key;
        String? pastDataString = entry.value;
        List<String> parts = pastDataString.split(' ');
        if (parts.length >= 2) {
            pastCycleLengths.add(int.parse(parts[0]));  // Assuming the first part is the cycle length
            pastCycleStartDates.add(parts[1]);          // Assuming the second part is the start date
            pastEntryDates.add(entryKey);               // The key is added as the entry date
        }
    }

    return CycleData(pastCycleLengths, pastCycleStartDates, pastEntryDates);
}

  static Future<void> updateCycleData(DateTime cycleStartDate, List<String> pastCycleStartDates, List<String> pastEntryDates) async {
    if (pastCycleStartDates.isNotEmpty && pastEntryDates.isNotEmpty) {
      try {
        // Convert the last start date from string to DateTime
        DateTime lastStartDate = stringToDate(pastCycleStartDates.last);

        // Calculate the difference in days
        int daysDifference = cycleStartDate.difference(lastStartDate).inDays;

        // Create the new entry string with the calculated days difference
        String lastEntry = '$daysDifference ${pastCycleStartDates.last}';

        // Get the key for the last entry
        String lastKey = pastEntryDates.last;

        // Ensure deletion of the last entry is completed before adding new data
        deleteLastEntry();  // Make sure this function actually waits for the DB operation to complete

        // Write the new data using the same last key
        writeCycleData(lastKey, lastEntry);
      } catch (e) {
          print('Error updating cycle data: $e');
          throw Exception('Failed to update cycle data: $e');  // Optional: rethrow to handle higher up
      }
    }else {
      print("No data to update");
    }
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
