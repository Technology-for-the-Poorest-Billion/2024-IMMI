import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'app_localizations.dart';


class SettingPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  SettingPage({required this.onLocaleChange});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingPage> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = 'en'; // Default to English
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('settings_title') ?? 'Settings'),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dark Mode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SwitchButton(),  // Assuming you have a switch widget for toggling dark mode
            SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.translate('language') ?? 'Language'),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(AppLocalizations.of(context)!.translate('english') ?? 'English'),
                ),
                DropdownMenuItem(
                  value: 'es',
                  child: Text(AppLocalizations.of(context)!.translate('spanish') ?? 'Spanish'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                  if (newValue != null) {
                    widget.onLocaleChange(Locale(newValue));
                  }
                });
              },
            ),
            // Additional buttons
            StyledButton(title: 'Button 1', onPressed: () {}),
            SizedBox(height: 10),
            StyledButton(title: 'Button 2', onPressed: () {}),
            SizedBox(height: 10),
            StyledButton(title: 'Button 3', onPressed: () {}),
            SizedBox(height: 10),
            StyledButton(title: 'Button 4', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const StyledButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink, // Background color
        foregroundColor: Colors.white, // Text color, replacing 'onPrimary'
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}


class SwitchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a Consumer widget or set listen to true to react to changes.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        bool isDarkMode = themeProvider.themeData.brightness == Brightness.dark;
        return Switch(
          value: isDarkMode,  // This will now update when the theme changes
          onChanged: (bool value) {
            themeProvider.toggleTheme();  // This will change the theme
          },
          activeColor: Colors.pink,
        );
      },
    );
  }
}
