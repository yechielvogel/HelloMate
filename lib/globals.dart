// globals.dart
library my_project.globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'getcontacts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

ContactInfo? randomContact;
String? randomContactName;
String? randomContactNumber;
int? retakeCounter = 1;
String stringretakeCounter = retakeCounter.toString();
int? scoreCounter;
String now = DateFormat('dd/MM/yyyy').format(DateTime.now());
bool systemSettings = false;

bool darkMode = false;
bool lightMode = false;
bool darkMode2 = false;
bool darkMode3 = false;
bool darkMode4 = false;
bool darkMode5 = false;
bool shouldAnimateBottomSheet = true;

Color colorMode = darkMode ? Colors.black : Colors.white;
Color colorMode2 = darkMode2 ? Colors.grey[900]! : Colors.grey[100]!;
Color colorMode3 = darkMode3 ? Colors.white : Colors.black;
Color colorMode4 = darkMode4 ? Colors.grey[100]! : Colors.grey[900]!;
Color colorMode5 = darkMode5 ? Colors.white70 : Colors.black54;

void saveScoreCounter(int score) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('scoreCounter', score);
}

Future<void> updateColorMode() async {
  colorMode = darkMode ? Colors.black : Colors.white;
  colorMode2 = darkMode2 ? Colors.grey[900]! : Colors.grey[100]!;
  colorMode3 = darkMode3 ? Colors.white : Colors.black;
  colorMode4 = darkMode4 ? Colors.grey[700]! : Colors.white70;
  colorMode5 = darkMode5 ? Colors.white70 : Colors.black54;
}
// Future<void> saveScoreCounter(int? score) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setInt('scoreCounter', score ?? 0);
// }



