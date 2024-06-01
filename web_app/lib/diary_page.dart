import 'package:flutter/material.dart';
import 'utils.dart';


class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime selectedDate = DateTime.now(); // Default to today's date
  TextEditingController diaryController = TextEditingController();
  late ScrollController  diaryScrollController;

  @override
  void initState() {
    super.initState();
    diaryScrollController = ScrollController();
    loadData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000), // Start date for date picker
      lastDate: DateTime(2100), // End date for date picker
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      loadData();  // Load data for the new date after updating
    }
  }

  void loadData() async {
    final dateStr = selectedDate.toLocal().toString().split(' ')[0];
    final key = 'entry_$dateStr';
    String? diaryEntry = await DiaryDataUtils.readData(key);
    if (diaryEntry != null) {
      setState(() {
        diaryController.text = diaryEntry;
      });
    }
    else {
      diaryController.clear();
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
                final dateStr = selectedDate.toLocal().toString().split(' ')[0];
                final key = 'entry_$dateStr';
                final diaryText = diaryController.text;
                print('Attempting to save data'); // Confirm this line is reached
                try {
                  await DiaryDataUtils.writeData(key, diaryText);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Diary entry saved successfully!'))
                  );
                  print('Diary entry saved'); // Confirm saving process
                } catch (e) {
                  print('Failed to save diary entry: $e'); // Check for errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save diary entry'))
                  );
                }
              },
              child: Text('Save Diary', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}
