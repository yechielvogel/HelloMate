import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'getcontacts.dart';
import 'sendtext.dart';
import 'message_bridge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: MyApp(key: myAppKey),
      ),
    ),
  );
}

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

  Color tileTextColor = globals.colorMode3;
  Color tileIconColor = globals.colorMode3;

  void rebuildWidgets() {
    setState(() {
      reloadWidgets();
    });
  }

  void rebuildShowBottomWidget() {
    setState(() {
      reloadModalBottomSheet();
    });
  }

  void reloadModalBottomSheet() {
    try {
      // Close the existing bottom sheet if it's open
      Navigator.of(context).pop();
    } catch (e) {
      // Handle the error if no element is found
      print('Error closing bottom sheet: $e');
    }

    // Show the updated bottom sheet with the new color
    showModalBottomSheet(
      backgroundColor: globals.colorMode2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => MyWidget(
        reloadCallback: () {},
      ),
    );
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
    List<String> tileWidgetScore = [];

    for (var tileWidget in tileWidgets) {
      tileWidgetTitles.add(tileWidget.title);
      tileWidgetRetakes.add(tileWidget.retake);
      tileWidgetTrailings.add(tileWidget.trailing);
      tileWidgetScore.add(tileWidget.score);
    }

    await prefs.setStringList('tileWidgetTitles', tileWidgetTitles);
    await prefs.setStringList('tileWidgetRetakes', tileWidgetRetakes);
    await prefs.setStringList('tileWidgetTrailings', tileWidgetTrailings);
    await prefs.setStringList(
        'tileWidgetScores', tileWidgetScore); // Corrected the key name
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
              trailing: globals.now.toString()));
      // tiledate:
      // var tiledate = today;
    });
  }

  void saveScoreCounter(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('scoreCounter', score);
  }

  Future<void> updateScoreCounter(int newScore) async {
    setState(() {
      globals.scoreCounter = newScore;
    });
    saveScoreCounter(newScore);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // restorationScopeId: 'root',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        scaffoldBackgroundColor: globals.colorMode,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: globals.colorMode,
            title: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Image.asset(
                  'lib/assets/HelloMateIcon.png',
                  width: 40,
                  height: 40,
                  color: Colors.yellow,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: (isPressed)
                    ? Icon(CupertinoIcons.gear_alt_fill)
                    : Icon(CupertinoIcons.gear),
                color: Colors.yellow,
                onPressed: () async {
                  setState(() {
                    isPressed = true;
                  });
                  showModalBottomSheet(
                    backgroundColor: globals.colorMode2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => MyWidget(
                      reloadCallback: () {
                        myAppKey.currentState?.reloadModalBottomSheet();
                        myAppKey.currentState?.rebuildShowBottomWidget();
                      },
                    ),
                  );

                  setState(() {
                    isPressed = false;
                  });
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: globals.colorMode,
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
            foregroundColor: globals.colorMode,
            elevation: 5,
            onPressed: () async {
              HapticFeedback.heavyImpact();
              await getContacts();
              String resultCode = await MessageBridge.sendmessage();
              if (resultCode == '1') {
                setState(() {
                  globals.scoreCounter = (globals.scoreCounter ?? 0) + 1;
                });
                await updateScoreCounter(globals.scoreCounter!);
                await addTileWidget();
                await saveTileWidgets();
                globals.retakeCounter = 1;
                print('retake counter: ' + globals.retakeCounter.toString());
              } else if (resultCode == '3') {
                globals.retakeCounter = (globals.retakeCounter ?? 0) + 1;
                print(globals.retakeCounter);
              }
            },
            child: const Icon(CupertinoIcons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void reloadWidgets() {
    loadTileWidgets();
    setState(() {});
  }

  bool isPressed = false;
  bool notPressed = false;

  //  void setState(() {
  //   lightMode = true;
  // });
}

class TileWidget extends StatelessWidget {
  final String title;
  final String retake;
  final String trailing;
  final String score;
  final String? tiledate;
  final VoidCallback? rebuildCallback;

  static List<String> tileTitles = [];

  const TileWidget({
    Key? key,
    required this.title,
    required this.retake,
    required this.trailing,
    required this.score,
    this.tiledate,
    this.rebuildCallback,
  }) : super(key: key);

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
            color: globals.colorMode2,
            boxShadow: [],
          ),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      CupertinoIcons.arrow_2_squarepath,
                      color: globals.colorMode4,
                      size: 15,
                    ),
                  ),
                  TextSpan(
                    text: '  ' + retake.toString(),
                    style: TextStyle(color: globals.colorMode4, fontSize: 12),
                  ),
                  WidgetSpan(
                    child: Container(width: 20),
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'lib/assets/HelloMateIcon.png',
                      color: globals.colorMode4,
                      width: 14,
                      height: 14,
                    ),
                  ),
                  TextSpan(
                    text: '  ' + score.toString(),
                    style: TextStyle(color: globals.colorMode4, fontSize: 12),
                  ),
                  WidgetSpan(
                    child: Container(width: 20),
                  ),
                  WidgetSpan(
                    child: Icon(
                      CupertinoIcons.share,
                      color: globals.colorMode4,
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
                        color: globals.colorMode4,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Text(
              getFormattedTrailing(trailing),
              style: TextStyle(fontSize: 10.0, color: globals.colorMode4),
            ),
            leading: const Icon(
              Icons.account_circle_rounded,
              size: 50,
            ),
            iconColor: globals.colorMode3,
            textColor: globals.colorMode3,
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

class MyWidget extends StatefulWidget {
  final void Function() reloadCallback;
  const MyWidget({Key? key, required this.reloadCallback}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Icon(
            CupertinoIcons.minus,
            size: 50,
            color: globals.colorMode3,
          ),
        ),
        SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16), // Apply left inset
              child: Text(
                'Dark mode',
                style: TextStyle(
                  fontSize: 25,
                  color: globals.colorMode3,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: 16, left: 16), // Apply right inset
              child: CupertinoSwitch(
                value: globals.darkMode,
                activeColor: CupertinoColors.systemYellow,
                onChanged: (bool? value) {
                  setState(() {
                    globals.darkMode = value ?? true;
                    globals.darkMode2 = value ?? true;
                    globals.darkMode3 = value ?? true;
                    globals.updateColorMode();
                    myAppKey.currentState?.rebuildWidgets();
                    myAppKey.currentState?.reloadModalBottomSheet();
                    myAppKey.currentState?.rebuildShowBottomWidget();
                    widget.reloadCallback();
                  });
                },
              ),
            ),
          ],
        ),
        Container(),
        const SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16, left: 16, bottom: 50),
              child: Text(
                'Use device settings',
                style: TextStyle(
                  fontSize: 25,
                  color: globals.colorMode3,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, left: 16, bottom: 50),
              child: CupertinoSwitch(
                value: globals.systemSettings,
                activeColor: CupertinoColors.systemYellow,
                onChanged: (bool? value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
