
// Widget buildSheet() => Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(
  //           child: Icon(
  //             CupertinoIcons.minus,
  //             size: 50,
  //             color: globals.colorMode3,
  //           ),
  //         ),
  //         SizedBox(height: 0),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.only(left: 16), // Apply left inset
  //               child: Text(
  //                 'Dark mode',
  //                 style: TextStyle(
  //                   fontSize: 25,
  //                   color: globals.colorMode3,
  //                   // fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding:
  //                   EdgeInsets.only(right: 16, left: 16), // Apply right inset
  //               child: CupertinoSwitch(
  //                 // This bool value toggles the switch.
  //                 value: globals.darkMode,
  //                 activeColor: CupertinoColors.systemYellow,
  //                 onChanged: (bool? value) {
  //                   // This is called when the user toggles the switch.
  //                   setState(() {
  //                     globals.darkMode = value ?? true;
  //                     globals.darkMode2 = value ?? true;
  //                     globals.darkMode3 = value ?? true;
  //                   });

  //                   globals.updateColorMode();
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //         Container(),
  //         const SizedBox(height: 0),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.only(right: 16, left: 16, bottom: 50),
  //               child: Text(
  //                 'Use device settings',
  //                 style: TextStyle(
  //                   fontSize: 25,
  //                   color: globals.colorMode3,
  //                   // fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(right: 16, left: 16, bottom: 50),
  //               child: CupertinoSwitch(
  //                 value: globals.systemSettings,
  //                 activeColor: CupertinoColors.systemYellow,
  //                 onChanged: (bool? value) {
  //                   setState(() {});
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     );
