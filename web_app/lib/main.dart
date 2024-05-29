import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'data_page.dart';
import 'diary_page.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'setting_page.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugins are initialized before runApp

  // Initialize LocalStorage
  final LocalStorage storage = LocalStorage('my_app_data.json');
  await storage.ready;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(ThemeData.light()),  // Initialize with light theme
      child: PeriodTrackerApp(storage: storage),  // Pass LocalStorage to the app
    ),
  );
}

class PeriodTrackerApp extends StatelessWidget {
  final LocalStorage storage;  // Add storage to your app class

  PeriodTrackerApp({required this.storage});  // Accept storage in the constructor

  @override
  Widget build(BuildContext context) {
    // Accessing the ThemeProvider from the provider package
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Period Tracker',
      theme: themeProvider.themeData,
      home: MainPage(storage: storage),  // Pass storage to MainPage
    );
  }
}

class MainPage extends StatefulWidget {
  final LocalStorage storage;  // Add storage to MainPage

  MainPage({required this.storage});  // Accept storage in the constructor

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

  List<Widget> _widgetOptions() => <Widget>[
    DataPage(),
    DiaryPage(storage: widget.storage),  // Pass storage to DiaryPage
    HomePage(),
    InfoPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Tracker'),
        backgroundColor: Colors.pink,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions(),
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
