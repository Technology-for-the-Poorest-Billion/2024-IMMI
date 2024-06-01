import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'utils.dart';


class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  ScrollController diaryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: DiaryDataUtils.getAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text('Empty'));
            }
            return ListView(
              controller: diaryScrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.all(15),
              children: [
                for(var note in snapshot.data!)
                  ItemNote(note: note)
              ],
            );
          }
          return SizedBox();
        },
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
  final Note note;
  const ItemNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddNoteScreen(note: note)));
      },
      child: Container(
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
                  Text(
                    DateFormat(DateFormat.ABBR_MONTH).format(note.notedate),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat(DateFormat.DAY).format(note.notedate),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  )),
                  const SizedBox(height: 3),
                  Text(
                    note.notedate.year.toString(),
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    note.description,
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
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState() {
    if(widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
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
          widget.note != null? IconButton(
            onPressed: () {
              showDialog(context: context, builder: (context) => AlertDialog(
                content: const Text('Delete this diary?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteNote();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Diary deleted successfully!'))
                      );
                    },
                    child: const Text('Yes')
                  )
                ],
              ));
            }, 
            icon: const Icon(Icons.delete_outline),
          ): const SizedBox(),
          IconButton(
            onPressed: () {
              widget.note == null?_addNote(): _updateNote();
              // Navigator.of(context).pop();
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

  _addNote() async {
    final note = Note(
      title: _title.text,
      description: _description.text,
      notedate: DateUtils.dateOnly(DateTime.now())
    );
    print(note.notedate);
    final key = note.toMap()['notedate'];
    final diaryText = '${note.toMap()['title']}////${note.toMap()['description']}';

    try {
      await DiaryDataUtils.writeData(key, diaryText);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diary entry saved successfully!'))
      );
      print('Diary entry saved'); // Confirm saving process
    } 
    catch(e) {
      print('Failed to save diary entry: $e'); // Check for errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save diary entry'))
      );
    }
  }

  _updateNote() async {
    final note = Note(
      title: _title.text,
      description: _description.text,
      notedate: widget.note!.notedate
    );
    final key = note.toMap()['notedate'];
    final diaryText = '${note.toMap()['title']}////${note.toMap()['description']}';

    // UPDATE INDEXDB

    try {
      await DiaryDataUtils.writeData(key, diaryText);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diary entry saved successfully!'))
      );
      print('Diary entry updated'); // Confirm saving process
    } 
    catch(e) {
      print('Failed to update diary entry: $e'); // Check for errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update diary entry'))
      );
    }
  }

  _deleteNote() async {
    Navigator.pop(context);

    final note = Note(
      title: _title.text,
      description: _description.text,
      notedate: DateUtils.dateOnly(DateTime.now())
    );
    final key = note.toMap()['notedate'];

    DiaryDataUtils.deleteNote(key);
  }
}

class Note {
  String title, description;
  DateTime notedate;

  Note({
    required this.title,
    required this.description,
    required this.notedate
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'notedate': notedate.toString()
    };
  }
}
