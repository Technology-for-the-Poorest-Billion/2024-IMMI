import 'package:flutter/material.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController diaryController = TextEditingController();

  // Function to show date picker and update the selected date
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        backgroundColor: Colors.purple,  // Adjusted to match your theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            SizedBox(height: 8),
            // Display the selected date
            Text(
              'Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextFormField(
                controller: diaryController,
                decoration: InputDecoration(
                  labelText: 'Enter your diary',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                minLines: 10, // Gives a larger text field
                keyboardType: TextInputType.multiline,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Here you can handle saving the diary text to persistent storage
                print('Saving Data for ${selectedDate.toLocal().toString().split(' ')[0]}: ${diaryController.text}');
              },
              child: Text('Save Diary'),
            ),
          ],
        ),
      ),
    );
  }
}
