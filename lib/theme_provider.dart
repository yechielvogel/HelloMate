// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with WidgetsBindingObserver, ChangeNotifier {
  SystemUiOverlayStyle _getSystemUIOverlayStyle() {
    if (isDarkMode ||
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
      return SystemUiOverlayStyle.light;
    } else {
      return SystemUiOverlayStyle.dark;
    }
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSystem', isSystem);
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSystem = prefs.getBool('isSystem') ?? false;
    themeMode =
        prefs.getBool('isDarkMode') ?? false ? ThemeMode.dark : ThemeMode.light;
    SystemChrome.setSystemUIOverlayStyle(_getSystemUIOverlayStyle());
    notifyListeners();
  }

  ThemeMode themeMode = ThemeMode.light;

  bool isSystem = false;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    if (isSystem) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      if (brightness == Brightness.dark) {
        // Set the theme to dark mode when device is in dark mode
        themeMode = ThemeMode.dark;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      } else if (brightness == Brightness.light) {
        // Set the theme to light mode when device is in light mode
        themeMode = ThemeMode.light;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      }

      notifyListeners();
    }
  }

  void toggleTheme(bool isOn) {
    if (isSystem &&
        isDarkMode &&
        WidgetsBinding.instance.window.platformBrightness == Brightness.light) {
      themeMode = ThemeMode.light;
      WidgetsBinding.instance.addObserver(this);
    }
    WidgetsBinding.instance.addObserver(this);

    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // Update status bar icon colors
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  void toggleSystem(bool isOn) {
    WidgetsBinding.instance.addObserver(this);

    isSystem = isOn;
    if (isSystem) {
      // Use system settings
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      WidgetsBinding.instance.addObserver(this);

      if (brightness == Brightness.dark) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        WidgetsBinding.instance.addObserver(this);
        if (isDarkMode &&
            isSystem &&
            WidgetsBinding.instance.window.platformBrightness ==
                Brightness.light) {
          themeMode = ThemeMode.light;
          WidgetsBinding.instance.addObserver(this);
        }

        // Set the theme to dark mode when device is in dark mode

        themeMode = ThemeMode.dark;
      } else {
        WidgetsBinding.instance.addObserver(this);

        // Set the theme to light mode when device is in light mode
        themeMode = ThemeMode.light;
      }

      SystemChrome.setSystemUIOverlayStyle(
        isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      );
    } else {
      WidgetsBinding.instance.addObserver(this);

      // Use manual settings
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      SystemChrome.setSystemUIOverlayStyle(
        isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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


//  if (WidgetsBinding.instance?.window.platformBrightness == Brightness.dark) {
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);