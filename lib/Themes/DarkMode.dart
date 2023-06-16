import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Colors.black,
        primary: Color(0xFF212121),
        secondary: Colors.white,
        tertiary: Color(0xFFEEEEEE)));


// class DarkMode {
//   static bool isDarkMode = false;
//   static bool useDeviceSettings = false;

//   static ThemeData getThemeData(BuildContext context) {
//     final themeData = useDeviceSettings
//         ? Theme.of(context)
//         : (isDarkMode ? darkTheme : Theme.of(context));

//     return themeData;
//   }
// }

// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme.dark(
//     background: Colors.black,
//     primary: Color(0xFF212121),
//     secondary: Colors.white,
//     tertiary: Color(0xFFEEEEEE),
//   ),
// );