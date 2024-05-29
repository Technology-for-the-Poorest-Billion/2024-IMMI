import 'package:flutter/material.dart';
import 'utils.dart'; // Import StorageUtil for handling data


class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime selectedDate = DateTime.now(); // Default to today's date
  TextEditingController diaryController = TextEditingController();

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
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          ItemNote(),
          ItemNote()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNoteScreen()));
        }
      ),
    );
  }
}

class ItemNote extends StatelessWidget {
  const ItemNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical:5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade100
            ),
            child: Column(
              children: [
                Text('Month'),
                const SizedBox(height: 3),
                Text('Day', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold
                )),
                const SizedBox(height: 3),
                Text('Year')
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'description',
                  style: TextStyle(
                  fontWeight: FontWeight.w300,
                  height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController _title;
  late TextEditingController _description;
  String diaryEntryTitle = '';
  String diaryEntryDescription = '';

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary Entry'),
        actions: [
          IconButton(
            onPressed: () {
              diaryEntryTitle = _title.text;
              diaryEntryDescription = _description.text;
              _title.clear();
              _description.clear();
              Navigator.of(context).pop();
            }, 
            icon: const Icon(Icons.done),
            )
        ],
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'Content here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                ),
                maxLines: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
