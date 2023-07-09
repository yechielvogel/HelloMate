import 'package:flutter/material.dart';

// class ThemeProvider extends ChangeNotifier {
//   ThemeMode themeMode = ThemeMode.dark;
//   bool get isDarkTest => themeMode == ThemeMode.dark;
//   void toggleTheme(bool isOn) {
//     themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Colors.black,
        primary: Color(0xFF212121),
        secondary: Colors.white,
        tertiary: Color(0xFFEEEEEE)));
