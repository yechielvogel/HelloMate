import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool isSystem = false;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    if (isSystem) {
      // If system switch is on, ignore manual theme changes
      return;
    }

    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // Update status bar icon colors
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  void toggleSystem(bool isOn) {
    isSystem = isOn;

    if (isSystem) {
      // Use system settings
      themeMode = ThemeMode.system;
    } else {
      // Use manual settings
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();

    // Update status bar icon colors based on theme mode
    if (themeMode != ThemeMode.system) {
      SystemChrome.setSystemUIOverlayStyle(
        isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      );
    }
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
          background: Colors.black,
          primary: Color(0xFF212121),
          secondary: Colors.white,
          tertiary: Color(0xFFEEEEEE)));

  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
          background: Colors.white,
          primary: Color(0xFFF5F5F5),
          secondary: Colors.black,
          tertiary: Color(0xFF212121)));
}
