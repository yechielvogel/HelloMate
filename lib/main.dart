import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'getcontacts.dart';
import 'sendtext.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    List<String> tileWidgetSubtitles =
        prefs.getStringList('tileWidgetSubtitles') ?? [];
    List<String> tileWidgetTrailings =
        prefs.getStringList('tileWidgetTrailings') ?? [];

    setState(() {
      tileWidgets = List<TileWidget>.generate(tileWidgetTitles.length, (index) {
        return TileWidget(
          title: tileWidgetTitles[index],
          subtitle: tileWidgetSubtitles[index],
          trailing: tileWidgetTrailings[index],
        );
      });
    });
  }

  void saveTileWidgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> tileWidgetTitles = [];
    List<String> tileWidgetSubtitles = [];
    List<String> tileWidgetTrailings = [];

    for (var tileWidget in tileWidgets) {
      tileWidgetTitles.add(tileWidget.title);
      tileWidgetSubtitles.add(tileWidget.subtitle);
      tileWidgetTrailings.add(tileWidget.trailing);
    }

    await prefs.setStringList('tileWidgetTitles', tileWidgetTitles);
    await prefs.setStringList('tileWidgetSubtitles', tileWidgetSubtitles);
    await prefs.setStringList('tileWidgetTrailings', tileWidgetTrailings);
  }

// add: if tilewidgets list is empty build a widget saying you have no hellos.
// make trailing actuall day if today then today if yesterday...

  void addTileWidget() async {
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
              subtitle: 'Hello mate been a while!',
              trailing: 'Today'));
      // tiledate:
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
                icon: const Icon(Icons.settings),
                color: Colors.black,
                onPressed: () async {},
              )
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
              // TileWidget(
              //   title: 'Yanky Vogel',
              //   subtitle: 'Hello mate been a while',
              //   trailing: 'Today',
              // ),
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
              await getContacts();
              await sendText();
              addTileWidget();
              saveTileWidgets();
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
  final String subtitle;
  final String trailing;
  final String? tiledate;

  const TileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.tiledate,
  });

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
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: Text(trailing, style: const TextStyle(fontSize: 10.0)),
            leading: const Icon(
              Icons.account_circle_rounded,
              size: 50,
            ),
            iconColor: Colors.yellow,
            textColor: Colors.yellow,
            onTap: () {},
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