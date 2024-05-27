// File: setting_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get theme => _themeData;

  set theme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    theme = _themeData.brightness == Brightness.light
        ? ThemeData.dark()
        : ThemeData.light();
  }
}

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Setting Page'),
            ElevatedButton(
              onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              child: Text('Dark Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
