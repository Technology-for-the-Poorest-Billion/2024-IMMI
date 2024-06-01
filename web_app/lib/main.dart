import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data_page.dart';
import 'new_diary_page.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'setting_page.dart';
import 'theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';


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

class PeriodTrackerApp extends StatefulWidget {
  @override
  _MenstrualCycleHomePageState createState() => _MenstrualCycleHomePageState();
}

class _MenstrualCycleHomePageState extends State<PeriodTrackerApp> {
  Locale _locale = Locale('en');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the ThemeProvider from the provider package
    final themeProvider = Provider.of<ThemeProvider>(context);
    List<Widget> _widgetOptions = <Widget>[
      DataPage(),
      DiaryPage(),
      HomePage(),
      InfoPage(),
      SettingPage(onLocaleChange: _setLocale),
    ];
    return MaterialApp(
      title: 'Period Tracker',
      theme: themeProvider.themeData,
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
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
      ),
      routes: {
        '/settings': (context) => SettingPage(onLocaleChange: _setLocale),
        '/info': (context) => InfoPage(),
      },
    );
  }
}
