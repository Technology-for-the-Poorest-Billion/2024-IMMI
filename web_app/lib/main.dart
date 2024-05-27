// File: main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_page.dart';
import 'diary_page.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'setting_page.dart';  // This import brings ThemeProvider and SettingPage

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(ThemeData.light()),  // Initialize with light theme
      child: PeriodTrackerApp(),
    ),
  );
}

class PeriodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Period Tracker',
      theme: themeProvider.theme,  // Use theme from themeProvider
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
      appBar: AppBar(
        title: Text('Period Tracker'),
      ),
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
