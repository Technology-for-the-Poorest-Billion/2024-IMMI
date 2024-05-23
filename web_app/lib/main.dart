import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bulleted_list/bulleted_list.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

void main() {
  runApp(PeriodTrackerApp());
}

class PeriodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    DataPage(),
    DiaryPage(),
    HomePage(),
    InfoPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Tracker'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

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
    _loadNotes();
  }

  /// Loads notes from SharedPreferences
  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = Map<String, String>.from(json.decode(prefs.getString('notes') ?? '{}'));
    });
  }

  /// Saves notes to SharedPreferences
  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes', json.encode(_notes));
  }

  /// Navigates the calendar to today's date and loads the note for today
  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
      _noteController.text = _notes[_focusedDay.toIso8601String()] ?? '';
    });
  }

  /// Opens the default date picker to select the period start date
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

  /// Calculates predicted period dates based on the selected start date
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

  /// Helper function to check if two DateTime objects represent the same calendar day
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
                return isSameDay(_selectedDay, day);
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
                  // Highlight predicted periods
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

  /// Helper function to count the number of weeks in a month
  int _getWeekCount(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    int numberOfDays = lastDayOfMonth.day - firstDayOfMonth.day + 1;
    return (numberOfDays / 7).ceil();
  }
}

class DataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Data Page'),
    );
  }
}

class DiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Diary Page'),
    );
  }
}

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
          Text('The Stages of the Menstrual Cycle', style:  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
          Text('Your menstrual cycle is every day of your life (until menapause!) so it’s important to track it. Each day, something different is happening so that’s why you’ll feel different during different phases of your cycle. We can break your cycle into 4 parts, it’s easy to understand them if you think about it like the Seasons. '),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:12)),
          Text('Winter', style: TextStyle(color: Colors.black.withOpacity(1), fontSize:18) ),
          Text('This is Phase 1 of your cycle and usually lasts from day 1-6 but this can vary. It’s the phase when you’re on your period (bleeding) and it’s the time to rest, like you’re hibernating in winter! ', textAlign: TextAlign.left),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:4)),
          BulletedList(
            bullet: Icon(
              Icons.ac_unit,
              color: Colors.pink,
              ),
              listItems: [
                      'Biologically -''what’s happening is that your uterus is shedding the lining that would have held the egg if it was fertilised. This lining has built up throughout the month and your body is now working hard to release the blood in the lining of your uterus, so it’s sending you all the signals to slow down and stop while it’s busy! ',
                      'Emotionally - you’re going to be feeling sensitive, tired and also like you can let go of everything. It’s like a physical and emotional release when your period comes, all the emotions can fly away too and tension can be released! You can take this time to really nurture yourself, get lots of sleep and even wear nice big warm jumpers.',
                      'Physically - you might feel some pain so cancel all social engagements and rest, rest, rest. Taking this downtime now will set you up for the rest of your cycle. If you don’t slow down, you may end up running on empty later which can make your PMS really intense.',
                      'Exercise - Gentle is the name of the game here - Light exercise can really help, especially if you are experiencing pain, so take time to go on gentle walks or do some light stretching. After a few days of bleeding you might feel energised so don’t hold back from an easy run if your body wants that. ',
                      'Diet - Up your iron! Think about granola for breakfast, chicken sandwiches for lunch and even some red meat or nice tofu dish for dinner with lots of leafy greens or tomatoes to help the iron absorb. Snacks like raisins and dried apricots are good too, and some orange juice. '
                    ], style:TextStyle(color: Color.fromARGB(255, 65, 64, 64).withOpacity(1), fontSize:11) ,
          ),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:18)),
          Text('Spring', style: TextStyle(color: Colors.black.withOpacity(1), fontSize:18) ),
          Text('This is the second phase of your cycle, when your period has finished, and before you ovulate. It usually lasts from days 7-13 but this can vary. ', textAlign: TextAlign.left),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:4)),
          BulletedList(
            bullet: Icon(
              Icons.spa,
              color: Colors.pink,
              ),
              listItems: [
                      'Biologically - what’s happening is your egg is preparing to be released. The egg leaves the ovary and travels down the fallopian tube towards the uterus. During this journey the egg will meet the sperm (if there is sperm present) and get fertilized to produce pregnancy. ',
                      'Emotionally - your hormone levels are starting to rise and you’ll be feeling more energetic, just like you’re coming out of hibernation in spring. Our oestrogen levels start to rise and we start to feel more energy, more motivation and full of hope, optimism and ideas.',
                      'Physically - you’ll be ready to exercise again, and that side hustle you’ve been thinking about - start getting it down on paper. Your creative juices are starting to flow so make the most of it. Meet up with friends, socialise and feel the energy!',
                      'Exercise - it’s a great time to work out at high intensity, potentially incorporating regular home workouts, or frequent walks at your local park or trips to the gym - whatever is suited to you & what you like. Pre-ovulation, your body temperature stays consistent, pain tolerance increases and the ability to digest and utilise carbohydrates is more efficient. So, in other words, go out and shift some steel and hit those personal bests! Be careful though as your ligaments and tendons are a bit more relaxed thanks to oestrogen, so don’t overstretch or do too much flexibility work during this phase as you might pull a muscle or twist an ankle or something! ',
                      'Diet - Salads with broccoli, salmon, avocados are great here - a sprinkle of superfoods, and it’s also important to have fermented foods which help with your gut health. This might be pickles or yoghurt. Nuts are a great snack also - you may consider these during your working day to remain energised and focused! '
                    ], style:TextStyle(color: Color.fromARGB(255, 65, 64, 64).withOpacity(1), fontSize:11) ,
          ),
        
        ],
        
      ),
      );
  
  }
}


class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Setting Page'),
    );
  }
}
