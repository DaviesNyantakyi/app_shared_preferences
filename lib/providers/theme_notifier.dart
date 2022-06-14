import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifer extends ChangeNotifier {
  ThemeData? _selectedTheme;

  ThemeData? get selectedTheme => _selectedTheme;

  ThemeNotifer({required bool isDarkMode}) {
    if (isDarkMode) {
      _selectedTheme = _darkMode;
    } else {
      _selectedTheme = _lightMode;
    }
  }

  final ThemeData _darkMode = ThemeData(
    scaffoldBackgroundColor: Colors.black87,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.yellow,
      secondary: Colors.yellow,
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all(Colors.yellow.shade300),
      thumbColor: MaterialStateProperty.all(Colors.yellow),
      overlayColor: MaterialStateProperty.all(
        Colors.yellow.shade100.withOpacity(0.5),
      ),
    ),
    primaryColor: Colors.indigoAccent,
    highlightColor: Colors.white.withOpacity(0.5),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  final ThemeData _lightMode = ThemeData(
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.indigoAccent,
      secondary: Colors.indigoAccent,
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all(Colors.blueGrey.shade300),
      thumbColor: MaterialStateProperty.all(Colors.indigoAccent),
    ),
    primaryColor: Colors.indigoAccent,
    highlightColor: Colors.indigoAccent.withOpacity(0.5),
    iconTheme: const IconThemeData(color: Colors.black),
  );

  Future<void> setTheme() async {
    final pref = await SharedPreferences.getInstance();
    if (_selectedTheme == _darkMode) {
      _selectedTheme = _lightMode;
      await pref.setBool('isDarkMode', false);
    } else {
      _selectedTheme = _darkMode;
      await pref.setBool('isDarkMode', true);
    }
    notifyListeners();
  }
}
