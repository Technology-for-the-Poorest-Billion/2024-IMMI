import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _periodStartDate;
  List<DateTime> _predictedPeriods = [];
  TextEditingController _noteController = TextEditingController();
  Map<String, String> _notes = {};
  int _cycleLength = 28;
  int _currentDay = 1;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();  // Initialize _selectedDay
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = Map<String, String>.from(json.decode(prefs.getString('notes') ?? '{}'));
    });
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes', json.encode(_notes));
  }

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
      _noteController.text = _notes[_focusedDay.toIso8601String()] ?? '';
    });
  }

  Future<void> _selectPeriodStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _periodStartDate) {
      setState(() {
        _periodStartDate = picked;
        print('Selected Period Start Date: $_periodStartDate');
        _calculatePredictedPeriods();
      });
    }
  }

  void _calculatePredictedPeriods() {
    _predictedPeriods.clear();
    if (_periodStartDate != null) {
      DateTime nextPeriod = _periodStartDate!;
      while (nextPeriod.isBefore(DateTime.now().add(Duration(days: 365)))) {
        _predictedPeriods.add(nextPeriod);
        nextPeriod = nextPeriod.add(Duration(days: _cycleLength));
      }
      print('Predicted Period Dates: $_predictedPeriods');
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Average Cycle Length',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_cycleLength > 1) _cycleLength--;
                              _calculatePredictedPeriods();
                            });
                          },
                        ),
                        Text(
                          '$_cycleLength days',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _cycleLength++;
                              _calculatePredictedPeriods();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Current Day of Cycle',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_currentDay > 1) _currentDay--;
                            });
                          },
                        ),
                        Text(
                          'Day $_currentDay',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _currentDay++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${DateFormat.yMMM().format(DateTime(_focusedDay.year, _focusedDay.month - 1, 1))}',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${DateFormat.yMMM().format(_focusedDay)}',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${DateFormat.yMMM().format(DateTime(_focusedDay.year, _focusedDay.month + 1, 1))}',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCalendar(DateTime(_focusedDay.year, _focusedDay.month - 1, 1), Colors.lightBlue.shade50, true),
                  _buildCalendar(_focusedDay, Colors.lightGreen.shade50, true),
                  _buildCalendar(DateTime(_focusedDay.year, _focusedDay.month + 1, 1), Colors.pink.shade50, true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(DateTime date, Color backgroundColor, bool fullHeight) {
    return Expanded(
      child: Container(
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
                dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date).substring(0, 1),
              ),
              headerVisible: false,
              selectedDayPredicate: (day) {
                return _isSameDay(_selectedDay!, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _noteController.text = _notes[selectedDay.toIso8601String()] ?? '';
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, focusedDay) {
                  if (_predictedPeriods.any((predictedDate) => _isSameDay(predictedDate, day))) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return null;
                },
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.pink.shade200,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(fontSize: 16),
                weekendTextStyle: TextStyle(fontSize: 16),
              ),
              daysOfWeekHeight: 25.0,
              rowHeight: 40.0,
            ),
            if (fullHeight) ...List.generate(6 - _getWeekCount(date), (index) => SizedBox(height: 40.0)),
          ],
        ),
      ),
    );
  }

  int _getWeekCount(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    int numberOfDays = lastDayOfMonth.day - firstDayOfMonth.day + 1;
    return (numberOfDays / 7).ceil();
  }
}
