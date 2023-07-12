import 'dart:convert';
// import 'dart:js';
/// import 'package:HelloMate/Themes/DarkMode.dart';
// import 'package:HelloMate/Themes/LightMode.dart';
import 'package:HelloMate/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;
import 'getcontacts.dart';
// import 'globals.dart';
import 'share_button.dart';
// import 'package:share_plus/share_plus.dart';
// import 'get_contacts_test.dart';
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
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Set status bar icon colors based on dark mode and system settings
          SystemChrome.setSystemUIOverlayStyle(
            _getSystemUIOverlayStyle(themeProvider),
          );

          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: Scaffold(
              body: MyApp(key: myAppKey),
            ),
          );
        },
      ),
    ),
  );
}

SystemUiOverlayStyle _getSystemUIOverlayStyle(ThemeProvider themeProvider) {
  if (themeProvider.isSystem) {
    // Use system settings
    return SystemUiOverlayStyle(
      statusBarBrightness:
          themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
      statusBarIconBrightness:
          themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
    );
  } else {
    // Use manual settings based on dark mode
    return SystemUiOverlayStyle(
      statusBarBrightness:
          themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
      statusBarIconBrightness:
          themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
    );
  }
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
    List<String> tileWidgetTitlesNumbers =
        prefs.getStringList('tileWidgetTitlesNumbers') ?? [];
    List<String> tileWidgetRetakes =
        prefs.getStringList('tileWidgetRetakes') ?? [];
    List<String> tileWidgetTrailings =
        prefs.getStringList('tileWidgetTrailings') ?? [];
    List<String> tileWidgetScores =
        prefs.getStringList('tileWidgetScores') ?? [];
    List<String> tileWidgetProfilePics =
        prefs.getStringList('tileWidgetProfilePics') ?? [];

    setState(() {
      tileWidgets = List<TileWidget>.generate(tileWidgetTitles.length, (index) {
        return TileWidget(
          title: tileWidgetTitles[index],
          titleNumbers: tileWidgetTitlesNumbers[index],
          retake: tileWidgetRetakes[index],
          trailing: tileWidgetTrailings[index],
          score: tileWidgetScores[index],
          profilePic: index < tileWidgetProfilePics.length
              ? tileWidgetProfilePics[index]
              : '',
        );
      });
    });
  }

  Future<void> saveTileWidgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> tileWidgetTitles = [];
    List<String> tileWidgetTitlesNumbers = [];
    List<String> tileWidgetRetakes = [];
    List<String> tileWidgetTrailings = [];
    List<String> tileWidgetScore = [];
    List<String> tileWidgetProfilePics = [];

    for (var tileWidget in tileWidgets) {
      tileWidgetTitles.add(tileWidget.title);
      tileWidgetTitlesNumbers.add(tileWidget.titleNumbers);
      tileWidgetRetakes.add(tileWidget.retake);
      tileWidgetTrailings.add(tileWidget.trailing);
      tileWidgetScore.add(tileWidget.score);
      tileWidgetProfilePics.add(tileWidget.profilePic ?? '');
    }

    await prefs.setStringList('tileWidgetTitles', tileWidgetTitles);
    await prefs.setStringList(
        'tileWidgetTitlesNumbers', tileWidgetTitlesNumbers);
    await prefs.setStringList('tileWidgetRetakes', tileWidgetRetakes);
    await prefs.setStringList('tileWidgetTrailings', tileWidgetTrailings);
    await prefs.setStringList('tileWidgetScores', tileWidgetScore);
    await prefs.setStringList('tileWidgetProfilePics',
        tileWidgetProfilePics); // Corrected the key name
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
              titleNumbers: globals.randomContactNumber ?? '',
              retake: globals.retakeCounter.toString(),
              score: globals.scoreCounter.toString(),
              trailing: globals.now.toString(),
              profilePic: globals.randomContact?.profilePic));

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
            // rememer to remove the three lines below
            await getContacts();
            print(globals.randomContact?.phoneNumber);
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // int savedScore = prefs.getInt('scoreCounter') ?? 0;
            // globals.scoreCounter = savedScore + 1;
            // await updateScoreCounter(globals.scoreCounter!);
            // await addTileWidget();
            // await saveTileWidgets();
            String resultCode = await MessageBridge.sendmessage();
            if (resultCode == '1') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int savedScore = prefs.getInt('scoreCounter') ?? 0;
              globals.scoreCounter = savedScore + 1;
              await updateScoreCounter(globals.scoreCounter!);
              await addTileWidget();
              await saveTileWidgets();
              globals.retakeCounter = 1;
              print('retake counter: ' + globals.retakeCounter.toString());
              print('score counter: ' + globals.scoreCounter.toString());
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
  final String titleNumbers;
  final String retake;
  final String trailing;
  final String score;
  final String? tiledate;
  final String? profilePic;

  static List<String> tileTitles = [];

  const TileWidget({
    Key? key,
    required this.title,
    required this.retake,
    required this.trailing,
    required this.score,
    required this.profilePic,
    required this.titleNumbers,
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
            onTap: () {
              HapticFeedback.heavyImpact();
              globals.textAgain = titleNumbers;
              print(title);
              sendText();
            },
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Container(
                  height: 20,
                  width: 50,
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 13,
                        child: Icon(
                          CupertinoIcons.arrow_2_squarepath,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          '  ' + retake.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Image.asset(
                        'lib/assets/HelloMateIcon.png',
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 14,
                        height: 14,
                      ),
                      Text(
                        '  ' + score.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 25,
                  padding: EdgeInsets.all(0),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      print(title + ' ' + retake);
                      globals.retakeNumber = retake;
                      retakeTry();
                      onShare(context);
                      // globals.shareButton();
                      print(globals.retakeNumber);
                      print(title + ' ' + retake);
                    },
                    child: Icon(
                      CupertinoIcons.share,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Text(
              getFormattedTrailing(trailing),
              style: TextStyle(
                fontSize: 10.0,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            leading: Container(
              width: 50,
              child: profilePic != null && profilePic!.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(base64Decode(profilePic!)),
                      radius: 23,
                    )
                  : const Icon(
                      Icons.account_circle_rounded,
                      size: 50,
                    ),
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
  globals.randomContactAvatar = globals.randomContact?.profilePic;
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
    // final themeProvider = Provider.of<ThemeProvider>(context);
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
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      bool isSystemDarkMode =
                          themeProvider.isSystem && themeProvider.isDarkMode;
                      bool isDarkModeOn =
                          themeProvider.isDarkMode || isSystemDarkMode;

                      return CupertinoSwitch(
                        value: isDarkModeOn,
                        activeColor: CupertinoColors.systemYellow,
                        onChanged: (value) {
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);

                          if (isSystemDarkMode) {
                            // If system switch is on and system theme is dark, do nothing
                            return;
                          }

                          provider.toggleTheme(value);
                        },
                      );
                    },
                  ))
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
                child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                  return CupertinoSwitch(
                    value: themeProvider.isSystem,
                    activeColor: CupertinoColors.systemYellow,
                    onChanged: (bool? value) {
                      final provider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      provider.toggleSystem(value ?? false);
                    },
                  );
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
