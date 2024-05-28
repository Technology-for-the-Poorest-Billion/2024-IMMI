import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
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
  int _currentDay = 1;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();  // Initialize _selectedDay
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
  DateTime startDateOfCycle = DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day).subtract(Duration(days: _currentDay - 1));

  // Format the start date to a more readable form, e.g., Jan 28, 2024
    String formattedStartDate = DateFormat('MMM d, y').format(startDateOfCycle);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text('Start Date of Cycle: $formattedStartDate', style: TextStyle(fontSize: 18.0, color: textColor)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      onPressed: () {},
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
          SizedBox(height: 20.0),
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
