// globals.dart
library my_project.globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'getcontacts.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';

ContactInfo? randomContact;
String? randomContactName;
String? randomContactNumber;
String? randomContactAvatar;
int? retakeCounter = 1;
String stringretakeCounter = retakeCounter.toString();
int? scoreCounter;
String now = DateFormat('dd/MM/yyyy').format(DateTime.now());
bool systemSettings = false;
String? textAgain;
String? retakeNumber;

bool shouldAnimateBottomSheet = true;
bool isDarkModeEnabled = false;
List<String> shareButtonList = [];

void saveScoreCounter(int score) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('scoreCounter', score);
}

class Globals {}

void updateThemeMode(Function setState) {
  setState(() {
    isDarkModeEnabled = !isDarkModeEnabled;
  });
}

Future<void> shareButton() async {
  // ignore: avoid_print
  print(randomContactName);
}
