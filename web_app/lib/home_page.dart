import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:web_app/prediction.dart';
import 'utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  int _currentDay = 1;
  late TextEditingController precedingController;
  late TextEditingController repetitionController;
  String correctedEntryDate = '';
  String correctedStartDate = '';

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();  // Initialize _selectedDay
    repetitionController = TextEditingController();
    precedingController = TextEditingController();
  }

  @override
  void dispose() {
    repetitionController.dispose();
    precedingController.dispose();
    super.dispose();
  }

  void displayAllData() async {
    Map<String, String?> allData = CycleDataUtils.readAllCycleData();
    // Use the data in the UI, handling nulls appropriately
    for (var entry in allData.entries) {
        String displayValue = entry.value ?? "No data available";
        print('Key: ${entry.key}, Value: $displayValue');
    }
  }

  void recordEntry(DateTime cycleStartDate, DateTime entryDate) async {
    var predictor = CyclePredictor();

    // Generate key from the entry date (using today's date)
    String entryKey = CycleDataUtils.dateToString(entryDate);

    // Load past data
    String? pastDataString = await CycleDataUtils.readCycleData(entryKey);
    List<int> pastCycleLengths = [];
    List<String> pastCycleStartDates = [];
    List<String> pastEntryDates = [];

    if (pastDataString != null) {
      List<String> parts = pastDataString.split(' ');
      if (parts.length >= 2) {
        pastCycleLengths.add(int.parse(parts[0]));
        pastCycleStartDates.add(parts[1]);
        pastEntryDates.add(entryKey);
      }
    }

    // Check for repeated or preceded entries based on loaded data
    bool repeated = pastEntryDates.contains(CycleDataUtils.dateToString(entryDate));
    if (repeated) {
      // Show a dialog to confirm the change of the start date
      final overrideStartDate = await repetitionDialog(pastCycleStartDates.last, CycleDataUtils.dateToString(cycleStartDate));
      
      if (overrideStartDate == null || overrideStartDate.isEmpty) return;

      if (overrideStartDate != pastCycleStartDates.last) {
        // If the dialog returns a new start date, remove the last entry from each list
        CycleDataUtils.deleteLastEntry();
      } else {
        // If no new date is chosen or it's the same, just return and do nothing
        return;
      }
    }

    // int errorCounter = 0;
    // if(cycleStartDate.difference(CycleDataUtils.stringToDate(pastCycleStartDates.last)).inDays <= 0 && pastCycleStartDates.isNotEmpty) {
    //   print('here');
    //   final correctedStartDate = await precedingDialog(pastCycleStartDates.last, CycleDataUtils.dateToString(cycleStartDate));
    //   if (correctedStartDate == null || correctedStartDate.isEmpty) return;
    //   cycleStartDate = CycleDataUtils.stringToDate(correctedStartDate);
    // }

    // Update data 

    //predict new cycle length based on past cycle lengths
    int predLength = predictor.predictLength(pastCycleLengths);

    // Create new entry string
    String newEntry = '$predLength ${CycleDataUtils.dateToString(cycleStartDate)}';

    // Save the new data to Hive
    await CycleDataUtils.writeCycleData(entryKey, newEntry);
  }

  @override
  Widget build(BuildContext context) {
    // Adjust colors dynamically based on theme
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var calendarBackgroundColor = [
      Colors.lightBlue.shade50,
      Colors.lightGreen.shade50,
      Colors.pink.shade50
    ].map((color) => isDarkMode ? color.withOpacity(0.3) : color).toList();

    // Calculate the start date of the cycle
    DateTime startDateOfCycle = DateTime(_today.year, _today.month, _today.day).subtract(Duration(days: _currentDay - 1));

    // Format the start date to a more readable form, e.g., Jan 28, 2024
    String formattedStartDate = DateFormat('MMM d, y').format(startDateOfCycle);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0), // Increased spacing here
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Center(
              child: Text('Start Date of Cycle: $formattedStartDate', style: TextStyle(fontSize: 18.0, color: textColor)),
            ),
          ),
          SizedBox(height: 20.0), // Increased spacing here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentDay = 1;
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(textColor)
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Current Day of Cycle', style: TextStyle(fontSize: 18.0, color: textColor)),
                    Row(
                      children: [
                        IconButton(icon: Icon(Icons.remove, color: textColor), onPressed: () {
                          setState(() {
                            if (_currentDay > 1) _currentDay--;
                          });
                        }),
                        Text('Day $_currentDay', style: TextStyle(fontSize: 18.0, color: textColor)),
                        IconButton(icon: Icon(Icons.add, color: textColor), onPressed: () {
                          setState(() {
                            _currentDay++;
                          });
                        }),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        recordEntry(startDateOfCycle, _today);
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(textColor)
                      ),
                      child: const Text('Record'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0), // Increased spacing here
          Expanded(
            child: Row(
              children: [
                buildCalendarWithLabel(DateTime(_focusedDay.year, _focusedDay.month - 1, 1), textColor, calendarBackgroundColor[0]),
                buildCalendarWithLabel(_focusedDay, textColor, calendarBackgroundColor[1]),
                buildCalendarWithLabel(DateTime(_focusedDay.year, _focusedDay.month + 1, 1), textColor, calendarBackgroundColor[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> repetitionDialog(String lastEntry, String thisEntry) 
  => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(26.0))),
      title: SizedBox(
        height: 30.0,
        child: Text('Repetition Error', style: TextStyle(fontSize: 20.0, color: Colors.black)),
      ),
      content: SizedBox(
        width: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text('Two dates are recorded today, please select which entry to keep.',
              style: TextStyle(fontSize: 16.0, color: Colors.black)
            ),
            SizedBox(
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue.shade100),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.blue.shade200)
                    ),
                  ),
                ),
                child: Text('Previous Entry on: $lastEntry', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                onPressed: () {
                  correctedEntryDate = lastEntry;
                  Navigator.of(context).pop(correctedEntryDate);
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green.shade100),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.green.shade200)
                    ),
                  ),
                ),
                child: Text('Current Entry on: $thisEntry', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                onPressed: () {
                  correctedEntryDate = thisEntry;
                  Navigator.of(context).pop(correctedEntryDate);
                },
              ),
            ),
          ],
        ),
      ),  
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(fontSize: 16.0, color: Colors.black)),
          onPressed: () {
            repetitionController.clear();
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

    Future<String?> precedingDialog(String lastDate, String thisDate) 
  => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(26.0))),
      title: SizedBox(
        height: 30.0,
        child: Text('Preceding Error', style: TextStyle(fontSize: 20.0, color: Colors.black)),
      ),
      content: SizedBox(
        width: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text('The date entered is invalid because it is earlier than the last recorded date, please retry.',
              style: TextStyle(fontSize: 16.0, color: Colors.black)
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Last Cycle Started on: $lastDate',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter new start date of cycle: YYYY-MM-DD'),
              controller: precedingController
            ),
          ],
        ),
      ),  
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(fontSize: 16.0, color: Colors.black)),
          onPressed: () {
            precedingController.clear();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Submit', style: TextStyle(fontSize: 16.0, color: Colors.black)),
          onPressed: () {
            Navigator.of(context).pop(precedingController.text);
          },
        ),
      ],
    ),
  );

  Widget buildCalendarWithLabel(DateTime date, Color textColor, Color backgroundColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            DateFormat.yMMM().format(date),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            textAlign: TextAlign.center,
          ),
          _buildCalendar(date, backgroundColor, textColor, true),
        ],
      ),
    );
  }

  Widget _buildCalendar(DateTime date, Color backgroundColor, Color textColor, bool fullHeight) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var todayColor = isDarkMode ? Colors.blue[900] : Colors.blue[200];
    var selectedColor = isDarkMode ? Colors.pink[900] : Colors.pink[200];

    return Container(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(date.year, date.month, 1),
            lastDay: DateTime.utc(date.year, date.month + 1, 0),
            focusedDay: date,
            calendarFormat: _calendarFormat,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: textColor),  // Use textColor for weekdays
              weekendStyle: TextStyle(color: textColor),  // Use textColor for weekends
              dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date).substring(0, 1),
            ),
            headerVisible: false,
            selectedDayPredicate: (day) => _isSameDay(_selectedDay!, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: todayColor, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: selectedColor, shape: BoxShape.circle),
              defaultTextStyle: TextStyle(fontSize: 16, color: textColor),
              weekendTextStyle: TextStyle(fontSize: 16, color: textColor),
            ),
            daysOfWeekHeight: 25.0,
            rowHeight: 40.0,
          ),
          if (fullHeight) ...List.generate(6 - _getWeekCount(date), (index) => SizedBox(height: 40.0)),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _getWeekCount(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    int numberOfDays = lastDayOfMonth.day - firstDayOfMonth.day + 1;
    return (numberOfDays / 7).ceil();
  }
}
