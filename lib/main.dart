import 'package:HelloMate/Themes/DarkMode.dart';
import 'package:HelloMate/Themes/LightMode.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'getcontacts.dart';
// import 'globals.dart';
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
      theme: globals.isDarkModeEnabled ? darkTheme : lightTheme,
      darkTheme: darkTheme,
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
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          bottom: false,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
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
                    icon: Icon(
                      isPressed
                          ? CupertinoIcons.gear_alt_fill
                          : CupertinoIcons.gear,
                    ),
                    color: Colors.yellow,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      setState(() {
                        isPressed = true;
                      });

                      showModalBottomSheet(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) => MyWidget(),
                      ).whenComplete(() {
                        setState(() {
                          isPressed = false;
                        });
                      });
                    },
                  ),
                ],
              ),
            ],
            body: Container(
              color: Theme.of(context).colorScheme.background,
              padding: const EdgeInsets.all(0),
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  ...tileWidgets,
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(bottom: 0),
        child: FloatingActionButton(
          backgroundColor: Colors.yellow,
          foregroundColor: Theme.of(context).colorScheme.background,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
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

  static List<String> tileTitles = [];

  const TileWidget({
    Key? key,
    required this.title,
    required this.retake,
    required this.trailing,
    required this.score,
    this.tiledate,
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
            color: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 15,
                    ),
                  ),
                  TextSpan(
                    text: '  ' + retake.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 12),
                  ),
                  WidgetSpan(
                    child: Container(width: 20),
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'lib/assets/HelloMateIcon.png',
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 14,
                      height: 14,
                    ),
                  ),
                  TextSpan(
                    text: '  ' + score.toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 12),
                  ),
                  WidgetSpan(
                    child: Container(width: 20),
                  ),
                  WidgetSpan(
                    child: Icon(
                      CupertinoIcons.share,
                      color: Theme.of(context).colorScheme.tertiary,
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
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Text(
              getFormattedTrailing(trailing),
              style: TextStyle(
                  fontSize: 10.0,
                  color: Theme.of(context).colorScheme.tertiary),
            ),
            leading: const Icon(
              Icons.account_circle_rounded,
              size: 50,
            ),
            iconColor: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.secondary,
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
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // the bool's and final below is a test for a dark mode could remove.
  // bool isDarkMode = false;
  // bool useDeviceSettings = false;
  @override
  Widget build(BuildContext context) {
    // final themeData = useDeviceSettings
    //     ? Theme.of(context)
    //     : (isDarkMode ? darkTheme : Theme.of(context));
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          // Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Icon(
              CupertinoIcons.minus,
              size: 50,
              color: Theme.of(context).colorScheme.secondary,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: 16, left: 16), // Apply right inset
                child: CupertinoSwitch(
                  value: globals.isDarkModeEnabled,
                  activeColor: CupertinoColors.systemYellow,
                  onChanged: (bool? value) {
                    setState(() {
                      globals.updateThemeMode(setState);
                      print(globals.isDarkModeEnabled);
                    });
                  },
                ),
              )
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 50),
                child: CupertinoSwitch(
                  value: false,
                  activeColor: CupertinoColors.systemYellow,
                  onChanged: (bool? value) {
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}


// @override
//   Widget build(BuildContext context) {
//     // theme: globals.isDarkModeEnabled ? darkTheme : lightTheme,
//     // darkTheme: darkTheme,
//     // restorationScopeId: 'root',
//     // theme: ThemeData(
//     //   splashColor: Colors.transparent,
//     //   highlightColor: Colors.transparent,
//     //   hoverColor: Colors.transparent,
//     //   scaffoldBackgroundColor: globals.colorMode,
//     // ),
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(50.0),
//         child: AppBar(
//           elevation: 0,
//           backgroundColor: Theme.of(context).colorScheme.background,
//           title: SizedBox(
//             width: 40,
//             height: 40,
//             child: Center(
//               child: Image.asset(
//                 'lib/assets/HelloMateIcon.png',
//                 width: 40,
//                 height: 40,
//                 color: Colors.yellow,
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(
//                 isPressed ? CupertinoIcons.gear_alt_fill : CupertinoIcons.gear,
//               ),
//               color: Colors.yellow,
//               splashColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               onPressed: () async {
//                 setState(() {
//                   isPressed = true;
//                 });

//                 showModalBottomSheet(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(20),
//                     ),
//                   ),
//                   context: context,
//                   builder: (context) => MyWidget(),
//                 ).whenComplete(() {
//                   setState(() {
//                     isPressed = false;
//                   });
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         color: Theme.of(context).colorScheme.background,
//         padding: const EdgeInsets.all(0),
//         child: ListView(
//           padding: const EdgeInsets.all(10),
//           children: [
//             ...tileWidgets,
//           ],
//         ),
//       ),
//       floatingActionButton: Container(
//         alignment: Alignment.bottomCenter,
//         margin: const EdgeInsets.only(bottom: 0),
//         child: FloatingActionButton(
//           backgroundColor: Colors.yellow,
//           foregroundColor: Theme.of(context).colorScheme.background,
//           splashColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           elevation: 5,
//           onPressed: () async {
//             HapticFeedback.heavyImpact();
//             await getContacts();
//             String resultCode = await MessageBridge.sendmessage();
//             if (resultCode == '1') {
//               setState(() {
//                 globals.scoreCounter = (globals.scoreCounter ?? 0) + 1;
//               });
//               await updateScoreCounter(globals.scoreCounter!);
//               await addTileWidget();
//               await saveTileWidgets();
//               globals.retakeCounter = 1;
//               print('retake counter: ' + globals.retakeCounter.toString());
//             } else if (resultCode == '3') {
//               globals.retakeCounter = (globals.retakeCounter ?? 0) + 1;
//               print(globals.retakeCounter);
//             }
//           },
//           child: const Icon(CupertinoIcons.add),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }