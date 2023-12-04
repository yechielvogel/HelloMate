import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HelloMate/shared/globals.dart' as globals;
import 'package:HelloMate/shared/loading.dart';

import '../androidsmsview.dart';
import '../getcontacts.dart';
import '../message_bridge.dart';
import '../sendtext.dart';
import '../settings.dart';
import '../share_button.dart';
import '../theme_provider.dart';
import '../wavinghand.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isTileListEmpty() {
    return tileWidgets.isEmpty;
  }

  // final WavingHandIconState? wavingHandState =
  //     WavingHandIcon.wavingHandKey.currentState;

  List<TileWidget> tileWidgets = [];

  @override
  void initState() {
    super.initState();
    loadTileWidgets();
  }

  bool isLoadingContacts = false;

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

  Future<void> addTileWidget() async {
    setState(() {
      tileWidgets.insert(
          0,
          TileWidget(
              title: globals.randomContactName ?? '',
              titleNumbers: globals.randomContactNumber ?? '',
              retake: globals.retakeCounter.toString(),
              score: globals.scoreCounter.toString(),
              // trailing: globals.faketrail,

              trailing: globals.now.toString(),
              profilePic: globals.randomContact?.profilePic));
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

  void sendandsaveandroid() async {
    print('android');
    print(globals.randomContact?.phoneNumber);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedScore = prefs.getInt('scoreCounter') ?? 0;
    globals.scoreCounter = savedScore + 1;
    await updateScoreCounter(globals.scoreCounter!);
    await addTileWidget();
    await saveTileWidgets();
    loadTileWidgets();
    globals.smsandroid = '0';
  }

  WavingHandIcon wavingHandIcon = WavingHandIcon(
    iconImagePath: 'lib/assets/HelloMateIcon.png',
    wavingHandIconKey: wavingHandIconKey,
  );
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
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
                centerTitle: true,
                title: SizedBox(
                  // change title to leading to make logo on the left.
                  width: 40,
                  height: 40,
                  child: Center(
                    child: WavingHandIcon(
                      wavingHandIconKey: wavingHandIconKey,
                      iconImagePath: 'lib/assets/HelloMateIcon.png',
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
                    color: isDarkMode(context) ? Colors.white : Colors.black,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      setState(() {
                        isPressed = true;
                      });
                      retrieveDefaultMessage();
                      showModalBottomSheet(
                        // isScrollControlled: true, //new
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        // builder: (context) => MyWidget(),
                        isScrollControlled: true,

                        builder: (context) => Settings(),
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
            //  body: Container(
            //   color: Theme.of(context).colorScheme.background,
            //   padding: const EdgeInsets.all(0),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowGlow();
                return false;
              },
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: isTileListEmpty() ? [EmptyListWidget()] : tileWidgets,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(bottom: 0),
        child: FloatingActionButton(
          backgroundColor: isDarkMode(context) ? Colors.yellow : Colors.yellow,
          foregroundColor: isDarkMode(context) ? Colors.black : Colors.black,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          elevation: 2,
          onPressed: () async {
            HapticFeedback.heavyImpact();
            PermissionStatus status = await Permission.contacts.status;
            if (status.isDenied) {
              status = await Permission.contacts.request();
            }

            // rememer to remove the lines below
            // globals.retakeCounter = 1;
            // globals.faketrail = 'Today';
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // int savedScore = prefs.getInt('scoreCounter') ?? 0;
            // globals.scoreCounter = savedScore + 1;
            // await updateScoreCounter(globals.scoreCounter!);
            // await addTileWidget();
            // await saveTileWidgets();
            // loadTileWidgets();

            // untill here.
            // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//            var iosInfo = await deviceInfo.iosInfo;
// var androidInfo = await deviceInfo.androidInfo;

// bool isRealDevice = iosInfo.isPhysicalDevice || androidInfo.isPhysicalDevice;
            if (Platform.isIOS) {
              print('ios');
              String resultCode = await MessageBridge.sendmessage();
              if (resultCode == '1') {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int savedScore = prefs.getInt('scoreCounter') ?? 0;
                globals.scoreCounter = savedScore + 1;
                await updateScoreCounter(globals.scoreCounter!);
                await addTileWidget();
                await saveTileWidgets();
                loadTileWidgets();
                await Future.delayed(Duration(milliseconds: 500));
                final WavingHandIconState wavingHandIconState =
                    wavingHandIconKey.currentState!;
                await wavingHandIconState.waveHandOnDemand();
                globals.retakeCounter = 1;
                print('retake counter: ' + globals.retakeCounter.toString());
                print('score counter: ' + globals.scoreCounter.toString());
              } else if (resultCode == '3') {
                globals.retakeCounter = (globals.retakeCounter ?? 0) + 1;
                print(globals.retakeCounter);
              }
            } else if (Platform.isAndroid) {
              Completer<void> _completer = Completer<void>();
              // WavingHandIconState wave = WavingHandIconState();

              // wave.waveHandOnDemand();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => smsAndroidView(completer: _completer),
                ),
              );   
              await _completer.future;
              // await Future.delayed(Duration(milliseconds: 500));
              // final WavingHandIconState wavingHandIconState =
              //     wavingHandIconKey.currentState!;
              // await wavingHandIconState.waveHandOnDemand();
              if (globals.smsandroid == '1') {
                print('android');
                print(globals.randomContact?.phoneNumber);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int savedScore = prefs.getInt('scoreCounter') ?? 0;
                globals.scoreCounter = savedScore + 1;
                await updateScoreCounter(globals.scoreCounter!);
                await addTileWidget();
                await saveTileWidgets();
                loadTileWidgets();
                await Future.delayed(Duration(milliseconds: 500));
                final WavingHandIconState wavingHandIconState =
                    wavingHandIconKey.currentState!;
                await wavingHandIconState.waveHandOnDemand();
                globals.retakeCounter = 1;
                globals.smsandroid = '0';
              } else if (globals.smsandroid == '2') {
                globals.retakeCounter = (globals.retakeCounter ?? 0) + 1;
                print(globals.retakeCounter);
              }
              //   // the code below does not work yet
              // } else {
              //   print('VM');
              //   print(globals.randomContact?.phoneNumber);
              //   SharedPreferences prefs = await SharedPreferences.getInstance();
              //   int savedScore = prefs.getInt('scoreCounter') ?? 0;
              //   globals.scoreCounter = savedScore + 1;
              //   await updateScoreCounter(globals.scoreCounter!);
              //   await addTileWidget();
              //   await saveTileWidgets();
              //   loadTileWidgets();
            }
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

// Future<void> callWavingHandClass() async {
//   WavingHandIcon wavingInstance = WavingHandIcon();
//   wavingInstance._StartWavingAnimation();
// }

  void reloadWidgets() {
    loadTileWidgets();
    setState(() {});
  }

  bool isPressed = false;
  bool notPressed = false;
}

Future<void> saveDefaultMessage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('preFilledText', globals.preFilledText);
}

Future<void> retrieveDefaultMessage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? preFilledText =
      prefs.getString('preFilledText'); // Retrieve the value

  if (preFilledText != null) {
    globals.preFilledText = preFilledText; // Use the retrieved value
    print('Retrieved preFilledText: $preFilledText');
    // You can assign it to a variable, use it in your UI, etc.
  } else {
    print('preFilledText not found in shared preferences.');
  }
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
                  height: 20,
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
              // trailing,
              // globals.faketrail,
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
  // ignore: unused_field
  TextEditingController _controller =
      TextEditingController(text: globals.preFilledText);

  // String preFilledText = "Hello mate, it's been a while. How's it going?";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
                padding: EdgeInsets.only(left: 16),
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
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    bool systemToggleDark =
                        themeProvider.isSystem && themeProvider.isDarkMode;
                    bool isDarkModeOn =
                        themeProvider.isDarkMode || systemToggleDark;

                    return CupertinoSwitch(
                      value: isDarkModeOn,
                      activeColor: Colors.yellow,
                      onChanged: (value) async {
                        //  await Future.delayed(
                        //       const Duration(milliseconds: 500));
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.toggleSystem(value);
                        if (systemToggleDark) {
                          provider.toggleTheme(value);
                          provider.toggleSystem(false);
                        } else {
                          provider.toggleTheme(value);
                          provider.toggleSystem(false);
                          await provider.saveSettings();
                        }
                      },
                    );
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
                child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                  return CupertinoSwitch(
                    value: themeProvider.isSystem,
                    activeColor: Colors.yellow,
                    onChanged: (value) async {
                      final provider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      provider.toggleSystem(value);
                      await provider.saveSettings();
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

class EmptyListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                // "You don't have no hellos, tap the yellow button to begin.",
                // "Welcome to HelloMate, tap the yellow button to begin, your hellos will appear here.",
                "Tap the button below to begin. your 'Hellos' will appear here.",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space between the two containers
          // Container(
          //   // Your second container here
          //   height: 570,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20),
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          //   // child: Center(
          //   //   child: Image.asset(
          //   //     'lib/assets/StartScreenShotWhite.png',
          //   //     height: 500,
          //   //   ),
          //   // ),
          // ),
        ],
      ),
    );
  }
}
