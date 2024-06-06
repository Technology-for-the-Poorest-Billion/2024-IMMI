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
  // @override
  // bool get wantKeepAlive => true;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  int _currentDay = 1;
  late TextEditingController precedingController;
  late TextEditingController repetitionController;
  String correctedEntryDate = '';
  String correctedStartDate = '';
  late TextEditingController dayController; // Controller for the day input
  Future<CycleData>? _cycleDataFuture;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();  // Initialize _selectedDay
    repetitionController = TextEditingController();
    precedingController = TextEditingController();
    dayController = TextEditingController(text: _currentDay.toString());
    _cycleDataFuture = CycleDataUtils.loadData();  // Load data once and use throughout
  }

  @override
  void dispose() {
    repetitionController.dispose();
    precedingController.dispose();
    dayController.dispose();
    super.dispose();
  }

  void _updateDay(String newDay) {
    int? dayNum = int.tryParse(newDay);
    if (dayNum != null && dayNum > 0) { // Validate to ensure day is positive
      setState(() {
        _currentDay = dayNum;
      });
    } else {
      // Reset to the last valid day if invalid input
      dayController.text = _currentDay.toString();
    }
  }

  void recordEntry(DateTime cycleStartDate, DateTime entryDate) async {
    var predictor = CyclePredictor();

    // Generate key from the entry date (using today's date)
    String entryKey = CycleDataUtils.dateToString(entryDate);

    // Load data
    CycleData cycleData = await CycleDataUtils.loadData();
    List<int> pastCycleLengths = cycleData.cycleLengths;
    List<String> pastCycleStartDates = cycleData.startDates;
    List<String> pastEntryDates = cycleData.entryDates;

    // Check for repeated or preceded entries based on loaded data
    bool repeated = pastEntryDates.contains(CycleDataUtils.dateToString(entryDate));
    if (repeated) {
      // Show a dialog to confirm the change of the start date
      final overrideStartDate = await repetitionDialog(pastCycleStartDates.last, CycleDataUtils.dateToString(cycleStartDate));
      
      if (overrideStartDate == null || overrideStartDate.isEmpty) return;

      if (overrideStartDate != pastCycleStartDates.last) {
        // If the dialog returns a new start date, remove the last entry from each list
        await CycleDataUtils.deleteLastEntry();
        pastCycleLengths.removeLast();
        pastCycleStartDates.removeLast();
        pastEntryDates.removeLast();
        // Assign override date as the new cycle start date
        cycleStartDate = CycleDataUtils.stringToDate(overrideStartDate);
      } else {
        // If no new date is chosen or it's the same, just return and do nothing
        return;
      }
    }
    
    if(pastCycleStartDates.isNotEmpty) {
      int precedingCounter = 0;
      bool invalidDate = false;
      while(cycleStartDate.difference(CycleDataUtils.stringToDate(pastCycleStartDates.last)).inDays <= 0 || invalidDate == true) {
        if (precedingCounter >= 3) {
          return;
        }
        final correctedStartDate = await precedingDialog(pastCycleStartDates.last, CycleDataUtils.dateToString(cycleStartDate));
        if (correctedStartDate == null || correctedStartDate.isEmpty) return;

        invalidDate = DateTime.tryParse(correctedStartDate) == null;
        if(invalidDate == true){
          precedingCounter ++;
          continue;
        }
        cycleStartDate = CycleDataUtils.stringToDate(correctedStartDate);
        precedingCounter ++;
      }
    }

    // Update data 
    CycleDataUtils.updateCycleData(cycleStartDate, pastCycleStartDates, pastEntryDates);

    cycleData = await CycleDataUtils.loadData();
    pastCycleLengths = cycleData.cycleLengths;

    //predict new cycle length based on past cycle lengths
    int predLength = predictor.predictLength(pastCycleLengths);

    // Create new entry string
    String newEntry = '$predLength ${CycleDataUtils.dateToString(cycleStartDate)}';

    // Save the new data to Hive
    await CycleDataUtils.writeCycleData(entryKey, newEntry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Date recorded successfully!'))
    );
  }

  @override
  Widget build(BuildContext context) {
    // Adjust colors dynamically based on theme
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var calendarBackgroundColor = [
      const Color.fromARGB(255, 124, 138, 144),
      Colors.lightGreen.shade50,
      Colors.pink.shade50
    ].map((color) => isDarkMode ? color.withOpacity(0.3) : color).toList();

    // Calculate the start date of the cycle
    DateTime startDateOfCycle = DateTime(_today.year, _today.month, _today.day).subtract(Duration(days: _currentDay - 1));
    // DateTime startDateOfCycle = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day).subtract(Duration(days: _currentDay - 1)); // For testing

    // Format the start date to a more readable form, e.g., Jan 28, 2024
    String formattedStartDate = DateFormat('MMM d, y').format(startDateOfCycle);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              jumpToToday();
            },
            icon: const Icon(Icons.today)
          ),
          IconButton(
            onPressed: () {
              setState(() {});
              refreshData();
            },
            icon: const Icon(Icons.refresh)
          )
        ],
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
                          dayController.text = _currentDay.toString();
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(textColor)
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text('Current Day of Cycle', style: TextStyle(fontSize: 18.0, color: textColor)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (_currentDay > 1) {
                                setState(() {
                                  _currentDay--;
                                  dayController.text = _currentDay.toString();
                                });
                              }
                            },
                          ),
                          SizedBox(
                            width: 50, // Width of the text field
                            child: TextField(
                              controller: dayController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onSubmitted: _updateDay,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _currentDay++;
                                dayController.text = _currentDay.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        recordEntry(startDateOfCycle, _today);
                        // recordEntry(startDateOfCycle, _selectedDay!); // For testing
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
        child: Text('Repetition Error', style: TextStyle(fontSize: 20.0, color: Colors.red[700])),
      ),
      content: SizedBox(
        width: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text('Two dates are recorded today, please select which entry to keep.',
              style: TextStyle(fontSize: 16.0, color: Colors.red[700])
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
                child: Text('Previous Entry is: $lastEntry', style: TextStyle(fontSize: 16.0, color: Colors.red[700])),
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
                child: Text('Current Entry is: $thisEntry', style: TextStyle(fontSize: 16.0, color: Colors.red[700])),
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
          child: Text('Cancel', style: TextStyle(fontSize: 16.0, color: Colors.red[700])),
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
        child: Text('Preceding Error', style: TextStyle(fontSize: 20.0, color: Colors.red[700])),
      ),
      content: SizedBox(
        width: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text('The date entered is invalid because it is earlier than the last recorded date, please retry.',
              style: TextStyle(fontSize: 16.0, color: Colors.red[700])
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
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // change to select date
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
          child: Text('Cancel', style: TextStyle(fontSize: 16.0, color: Colors.red[700])),
          onPressed: () {
            precedingController.clear();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Submit', style: TextStyle(fontSize: 16.0, color: Colors.red[700])),
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
    
    // Define colors
    var todayColor = isDarkMode ? Color(0xFF82B1FF) : Colors.blue[200];
    var selectedColor = isDarkMode ? Color(0xFF424242) : Colors.blue;
    var cycleColor = isDarkMode ? Color(0xFF69F0AE) : Colors.green;
    var previousFertileColor = isDarkMode ? Color(0xFFFFAB91) : Colors.orange[200]; // Color for previous cycles' fertile window
    var predictionColor = isDarkMode ? Color(0xFFB39DDB) : Colors.deepPurple[200]; // Prediction color
    var fertileColor = isDarkMode ? Color(0xFFFF5252) : Colors.red;

    return FutureBuilder<CycleData>(
      future: _cycleDataFuture,
      builder: (context, snapshot) {
        bool hasData = snapshot.hasData && snapshot.data!.startDates.isNotEmpty && snapshot.data!.cycleLengths.isNotEmpty;

        // Define calendar logic for dates
        DateTime? lastCycleStartDate;
        DateTime? predictionStartDate;
        DateTime? predictedFertileStart;
        DateTime? predictedFertileEnd;
        List<DateTime> fertileStarts = [];
        List<DateTime> fertileEnds = [];

        if (hasData) {
            lastCycleStartDate = DateFormat('yyyy-MM-dd').parse(snapshot.data!.startDates.last);
            int lastCycleLength = snapshot.data!.cycleLengths.last;
            predictionStartDate = lastCycleStartDate.add(Duration(days: lastCycleLength));
            predictedFertileStart = predictionStartDate.add(Duration(days: 7));
            predictedFertileEnd = predictionStartDate.add(Duration(days: 18));
            for (var i = 0; i < snapshot.data!.startDates.length; i++) {
                DateTime start = DateFormat('yyyy-MM-dd').parse(snapshot.data!.startDates[i]);
                DateTime fertileStart = start.add(Duration(days: 7));
                DateTime fertileEnd = start.add(Duration(days: 18));

                fertileStarts.add(fertileStart);
                fertileEnds.add(fertileEnd);
            }
        }

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
                    weekdayStyle: TextStyle(color: textColor),
                    weekendStyle: TextStyle(color: textColor),
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
                    defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                    outsideDecoration: BoxDecoration(shape: BoxShape.circle),
                    defaultTextStyle: TextStyle(fontSize: 16, color: textColor),
                    weekendTextStyle: TextStyle(fontSize: 16, color: textColor),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (_isSameDay(_selectedDay!, day)) {
                        return Container(
                          decoration: BoxDecoration(
                            color: selectedColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(7),
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (predictionStartDate != null && _isSameDay(predictionStartDate, day)) {
                        return Container(
                          decoration: BoxDecoration(
                            color: predictionColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3),
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return null;  // Use default style
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                          color: todayColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(7),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                    markerBuilder: (context, day, events) {
                      List<Widget> markers = [];

                      // Check for cycle start dates and mark them
                      if (hasData && snapshot.data!.startDates.contains(DateFormat('yyyy-MM-dd').format(day))) {
                        return Container(
                          decoration: BoxDecoration(
                            color: cycleColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      // Mark previous cycles' fertile windows
                      for (int i = 0; i < fertileStarts.length; i++) {
                        if (day.isAfter(fertileStarts[i]) && day.isBefore(fertileEnds[i])) {
                            return Container(
                            decoration: BoxDecoration(
                              color: previousFertileColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            child: Text(
                            day.day.toString(),
                            style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                      }

                      // Mark predicted fertile period for the last cycle
                      if (predictedFertileStart != null && predictedFertileEnd != null &&
                        day.isAfter(predictedFertileStart) && day.isBefore(predictedFertileEnd)) {
                        return Container(
                          decoration: BoxDecoration(
                            color: fertileColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3),
                          child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return markers.isEmpty ? null : Stack(children: markers);
                    },
                  ),
                  daysOfWeekHeight: 25.0,
                  rowHeight: 40.0,
                ),
                if (fullHeight) ...List.generate(6 - _getWeekCount(date), (index) => SizedBox(height: 40.0)),
              ],
            ),
          );
      },
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

  void jumpToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
  }

  void refreshData() {
    setState(() {
      _cycleDataFuture = CycleDataUtils.loadData();
    });
  }
}
