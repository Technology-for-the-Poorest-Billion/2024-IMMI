import 'package:hive/hive.dart';
import 'new_diary_page.dart';
import 'data_page.dart';

// Define the structure to store cycle data including lengths, start dates, and entry dates.
class CycleData {
  List<int> cycleLengths;
  List<String> startDates;
  List<String> entryDates;

  CycleData(this.cycleLengths, this.startDates, this.entryDates);
}

// Utility class for managing cycle data using the Hive NoSQL database.
class CycleDataUtils {
  // Private getter to access the Hive box where cycle data is stored.
  static Box<String> get _box => Hive.box<String>('cycleData');

  // Save cycle data to the Hive database.
  static Future<void> writeCycleData(String key, String value) async {
    await _box.put(key, value);
  }

  // Retrieve cycle data from the Hive database.
  static String? readCycleData(String key) {
    return _box.get(key);
  }

  // Convert a DateTime to a formatted string (YYYY-MM-DD).
  static String dateToString(DateTime date) {
    String year = date.year.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // Convert a formatted string back to a DateTime object.
  static DateTime stringToDate(String date) {
    return DateTime.parse(date);
  }

  // Generate a string entry for a cycle record.
  static String generateEntry(int cycleLength, DateTime cycleStartDate, DateTime entryDate) {
    return '${cycleLength.toString()} ${dateToString(cycleStartDate)} ${dateToString(entryDate)}';
  }

  // Split a stored entry back into its component parts.
  static List<dynamic> separateEntry(String entry) {
    List<String> separated = entry.split(' ');
    int cycleLength = int.parse(separated[0]);
    String cycleStartDate = separated[1];
    String entryDate = separated[2];
    return [cycleLength, cycleStartDate, entryDate];
  }

  // Delete the most recent entry in the database.
  static Future<void> deleteLastEntry() async {
    if (_box.isNotEmpty) {
      var lastKey = _box.keys.last;
      await _box.delete(lastKey);
    }
  }

  // Clear all entries from the database.
  static Future<void> deleteAllEntry() async {
    await _box.clear();
  }

  // Read all cycle data from the database and return it as a map.
  static Future<Map<String, String>> readAllCycleData() async {
    Map<String, String> allData = {};
    var boxMap = await _box.toMap();
    boxMap.forEach((key, value) {
      allData[key.toString()] = value.toString();
    });
    return allData;
  }

  // Retrieve all cycle data and convert it into a list of structured data.
  static Future<List<TableCycleData>> getAllCycleData() async {
    Map<String, String> allData = await readAllCycleData();
    List<TableCycleData> pastData = [];

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

  // Load data from the database and construct a CycleData instance.
  static Future<CycleData> loadData() async {
    Map<String, String> allData = await readAllCycleData();
    List<int> pastCycleLengths = [];
    List<String> pastCycleStartDates = [];
    List<String> pastEntryDates = [];

    for (var entry in allData.entries) {
      String entryKey = entry.key;
      String? pastDataString = entry.value;
      List<String> parts = pastDataString.split(' ');
      if (parts.length >= 2) {
        pastCycleLengths.add(int.parse(parts[0]));
        pastCycleStartDates.add(parts[1]);
        pastEntryDates.add(entryKey);
      }
    }

    return CycleData(pastCycleLengths, pastCycleStartDates, pastEntryDates);
  }

  // Update cycle data with new entry calculations.
  static Future<void> updateCycleData(DateTime cycleStartDate, List<String> pastCycleStartDates, List<String> pastEntryDates) async {
    if (pastCycleStartDates.isNotEmpty && pastEntryDates.isNotEmpty) {
      try {
        DateTime lastStartDate = stringToDate(pastCycleStartDates.last);
        int daysDifference = cycleStartDate.difference(lastStartDate).inDays;
        String lastEntry = '$daysDifference ${pastCycleStartDates.last}';
        String lastKey = pastEntryDates.last;

        deleteLastEntry();  // Await deletion of the last entry.
        writeCycleData(lastKey, lastEntry);
      } catch (e) {
        print('Error updating cycle data: $e');
        throw Exception('Failed to update cycle data: $e');
      }
    } else {
      print("No data to update");
    }
  }
}

class DiaryDataUtils {
  // Access the diary data stored in a separate Hive box.
  static Box<String> get _box => Hive.box<String>('diaryBox');

  // Save a diary entry to the Hive database.
  static Future<void> writeData(String key, String value) async {
    try {
      await _box.put(key, value);
      print('Data saved');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Retrieve a diary entry from the Hive database.
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

  // Get all diary entries as a map.
  static Map<String, String> getAllEntries() {
    return Map.fromEntries(
      _box.keys.cast<String>().map((key) => MapEntry(key, _box.get(key) ?? "No entry found"))
    );
  }

  // Delete a specific diary note.
  static Future<void> deleteNote(String key) async {
    if(_box.keys.contains(key)) {
      await _box.delete(key);
    }
  }

  // Retrieve all notes from the database and convert them into structured data.
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
