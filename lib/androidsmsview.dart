import 'dart:async';
import 'smsandroidT.dart';
import 'package:HelloMate/sendsms_android.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'shared/globals.dart';
// import 'main.dart';

class smsAndroidView extends StatefulWidget {
  final Completer<void> completer;

  smsAndroidView({required this.completer});
  @override
  _smsAndroidViewState createState() => _smsAndroidViewState();
}

class _smsAndroidViewState extends State<smsAndroidView> {
  Completer<void> loadingCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    // String preFilledText = "Hello mate, it's been a while. How's it going?";
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        title: Text("New Hello",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        centerTitle: true,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 23.0),
            child: InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                smsandroid = "2";
                print(smsandroid);
                widget.completer.complete();
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 20, color: Colors.yellow),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "To:    ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '${randomContactName}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 100,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  maxLines: null,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  ),
                  controller: TextEditingController(
                    text: preFilledText,
                  ),
                  style: const TextStyle(fontSize: 20),
                )),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.arrow_up_circle_fill,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  onPressed: () async {
                    // sendSms();
                    await sendSms();
                    widget.completer.complete();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
