// globals.dart
library my_project.globals;

// import 'package:shared_preferences/shared_preferences.dart';
import 'getcontacts.dart';
import 'package:intl/intl.dart';

ContactInfo? randomContact;
String? randomContactName;
String? randomContactNumber;
int? retakeCounter = 1;
String stringretakeCounter = retakeCounter.toString();
int? scoreCounter = 0;
String now = DateFormat('dd/MM/yyyy').format(DateTime.now());


// Future<void> saveScoreCounter(int? score) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setInt('scoreCounter', score ?? 0);
// }



// globals.scoreCounter = 10;
// globals.saveScoreCounter(globals.scoreCounter);

// Future<int?> getScoreCounter() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getInt('scoreCounter');
// }

// globals.scoreCounter = await getScoreCounter();
