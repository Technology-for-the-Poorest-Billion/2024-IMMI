import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data_page.dart';
import 'diary_page.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'setting_page.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('cycleData');  // Open a new box for cycle data
  await Hive.openBox<String>('diaryBox');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(ThemeData.light()),
      child: PeriodTrackerApp(),
    ),
  );
}

class PeriodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accessing the ThemeProvider from the provider package
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Period Tracker',
      theme: themeProvider.themeData,
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

  List<Widget> _widgetOptions = <Widget>[
    DataPage(),
    DiaryPage(),
    HomePage(),
    InfoPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Cycle Tracker'),
      //   backgroundColor: Color.fromARGB(255, 255, 217, 187),
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
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