import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'getcontacts.dart';
import 'sendtext.dart';
import 'message_bridge.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// import 'package:sms_advanced/sms_advanced.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<TileWidget> tileWidgets = [];

  @override
  void initState() {
    super.initState();
    loadTileWidgets();
  }

  void loadTileWidgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tileWidgetTitles =
        prefs.getStringList('tileWidgetTitles') ?? [];
    List<String> tileWidgetRetakes =
        prefs.getStringList('tileWidgetRetakes') ?? [];
    List<String> tileWidgetTrailings =
        prefs.getStringList('tileWidgetTrailings') ?? [];
    List<String> tileWidgetScores =
        prefs.getStringList('tileWidgetScores') ?? [];

    setState(() {
      tileWidgets = List<TileWidget>.generate(tileWidgetTitles.length, (index) {
        return TileWidget(
          title: tileWidgetTitles[index],
          retake: tileWidgetRetakes[index],
          trailing: tileWidgetTrailings[index],
          score: tileWidgetScores[index],
        );
      });
    });
  }

  Future<void> saveTileWidgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> tileWidgetTitles = [];
    List<String> tileWidgetRetakes = [];
    List<String> tileWidgetTrailings = [];
    List<String> tileWidgetScores = [];

    for (var tileWidget in tileWidgets) {
      tileWidgetTitles.add(tileWidget.title);
      tileWidgetRetakes.add(tileWidget.retake);
      tileWidgetTrailings.add(tileWidget.trailing);
      tileWidgetScores.add(tileWidget.score);
    }

    await prefs.setStringList('tileWidgetTitles', tileWidgetTitles);
    await prefs.setStringList('tileWidgetRetakes', tileWidgetRetakes);
    await prefs.setStringList('tileWidgetTrailings', tileWidgetTrailings);
    await prefs.setStringList(
        'tileWidgetScores', tileWidgetScores); // Corrected the key name
  }

// add: if tilewidgets list is empty build a widget saying you have no hellos.
// make trailing actuall day if today then today if yesterday...

  Future<void> addTileWidget() async {
    // DateTime now = DateTime.now();
    // String today = DateFormat('dd/MM/yyy').format(now);

    // print(
    //   globals.randomContactName,
    // );
    // print(globals.randomContactNumber);
    setState(() {
      tileWidgets.insert(
          0,
          TileWidget(
              title: globals.randomContactName ?? '',
              retake: globals.retakeCounter.toString(),
              score: globals.scoreCounter.toString(),
              trailing: globals.now.toString())); // tiledate:
      // var tiledate = today;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'root',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.yellow,
            title: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Image.asset(
                  'lib/assets/HelloMateIcon.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(CupertinoIcons.gear_alt_fill),
                  color: Colors.black,
                  onPressed: () async {
                    //showBottomSheet(context: context, builder: (context) => buildSheet());},
                  })
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(0),
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              ...tileWidgets,
            ],
          ),
        ),
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 0),
          child: FloatingActionButton(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            elevation: 5,
            onPressed: () async {
              HapticFeedback.heavyImpact();
              await getContacts();
              String resultCode = await MessageBridge.sendmessage();
              if (resultCode == '1') {
                globals.scoreCounter = (globals.scoreCounter ?? 0) + 1;
                await addTileWidget();
                await saveTileWidgets();
                globals.retakeCounter = 1;
                print('retake counter: ' + globals.retakeCounter.toString());
              } else if (resultCode == '3') {
                globals.retakeCounter = (globals.retakeCounter ?? 0) + 1;
                print(globals.retakeCounter);
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class TileWidget extends StatelessWidget {
  final String title;
  final String retake;
  final String trailing;
  final String score;
  final String? tiledate;
  static List<String> tileTitles = [];
  const TileWidget({
    super.key,
    required this.title,
    required this.retake,
    required this.trailing,
    required this.score,
    this.tiledate,
  });
  String getFormattedTrailing(String trailing) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));

    DateFormat formatter = DateFormat('dd/MM/yyyy');
    DateTime trailingDate = formatter.parse(trailing);

    if (trailingDate.year == now.year &&
        trailingDate.month == now.month &&
        trailingDate.day == now.day) {
      return 'Today';
    } else if (trailingDate.year == yesterday.year &&
        trailingDate.month == yesterday.month &&
        trailingDate.day == yesterday.day) {
      return 'Yesterday';
    } else {
      // Format trailingDate using a date format of your choice
      return formatter.format(trailingDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 10,
          color: Colors.transparent,
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.7), blurRadius: 5),
            ],
          ),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: // Text(subtitle),
                Text.rich(
              TextSpan(
                children: [
                  const WidgetSpan(
                    child: Icon(
                      CupertinoIcons.arrow_2_squarepath,
                      color: Colors.white70,
                      size: 15,
                    ),
                  ),
                  TextSpan(
                      text: '  ' + retake.toString(),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                  WidgetSpan(
                    child: Container(width: 20),
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'lib/assets/HelloMateIcon.png',
                      color: Colors.white70,
                      width: 14,
                      height: 14,
                    ),
                  ),
                  TextSpan(
                      text: '  ' + score.toString(),
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  WidgetSpan(
                    child: Container(width: 20),
                  ),
                  const WidgetSpan(
                    child: Icon(
                      CupertinoIcons.share,
                      color: Colors.white70,
                      size: 15,
                    ),
                  ),
                  WidgetSpan(
                    child: Container(width: 20),
                  ),
                  WidgetSpan(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        sendText();
                        print('object');
                      },
                      child: Icon(
                        CupertinoIcons.chat_bubble,
                        color: Colors.white70,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Text(getFormattedTrailing(trailing),
                style: const TextStyle(fontSize: 10.0)),
            leading: const Icon(
              Icons.account_circle_rounded,
              size: 50,
            ),
            iconColor: Colors.white,
            textColor: Colors.white,
            // onLongPress: () =>
            //     {MessageBridge.sendmessage(), HapticFeedback.heavyImpact()},
          ),
        ),
      ],
    );
  }
}

Future<void> getContacts() async {
  globals.randomContact = await getRandomContact();
  globals.randomContactName = globals.randomContact?.name;
  globals.randomContactNumber = globals.randomContact?.phoneNumber;
}

// DateTime now = DateTime.now();
//     String today = DateFormat('dd-MM-yyy').format(now);

//     if (today == DateFormat('dd-MM-yyy').format(DateTime.now())) {
//       today = 'today';
//     } else if (today ==
//         DateFormat('dd-MM-yyy')
//             .format(DateTime.now().subtract(Duration(days: 1)))) {
//       today = 'yesterday';
//     } else {
//       today = today;
//     }
