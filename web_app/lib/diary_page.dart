import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'storage_manager.dart';


class DiaryPage extends StatefulWidget {
  final LocalStorage storage;  // Define a variable to hold the LocalStorage instance

  DiaryPage({required this.storage});  // Modify constructor to accept LocalStorage

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController diaryController = TextEditingController();
  late ScrollController  diaryScrollController;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    diaryScrollController = ScrollController();
    loadData();
  }

  void loadData() async {
    // Assume the key 'diary_entry' is used to store the diary text
    String key = 'diary_entry';
    String? diaryEntry = await StorageManager.loadData(key);
    if (diaryEntry != null) {
      setState(() {
        diaryController.text = diaryEntry;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,


          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(width: 20),
                Text(
                  'Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextFormField(
                controller: diaryController,
                scrollController: diaryScrollController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter your diary',
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
                keyboardType: TextInputType.multiline,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Use a key that includes the date to distinguish entries by day
                String key = 'diary_entry_${selectedDate.toIso8601String().split('T')[0]}';
                String value = diaryController.text;  // Text from the TextFormField
                await StorageManager.saveData(key, value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Diary entry saved for ${selectedDate.toLocal().toString().split(' ')[0]}!'))
                );
              },
              child: Text('Save Diary', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}