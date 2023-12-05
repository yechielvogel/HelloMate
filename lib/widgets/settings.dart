import 'package:HelloMate/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:HelloMate/shared/globals.dart' as globals;

import '../Themes/theme_provider.dart';

class Settings extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Settings> {
  retrieveDefaultMessage() {
    throw UnimplementedError();
  }

  TextEditingController _controller =
      TextEditingController(text: globals.preFilledText);
  bool isTyping = false;
  // String preFilledText = "Hello mate, it's been a while. How's it going?";
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        if (overscroll.leading) {
          // Scroll down to dismiss the keyboard
          FocusScope.of(context).unfocus(); // Close the keyboard
          return true; // Consume the notification
        }
        return false; // Allow normal overscroll behavior
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.minus,
                  size: 50,
                  color: isDarkMode(context) ? Colors.white : Colors.black,
                ),
                SizedBox(height: 0),
                Container(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
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
                          bool systemToggleDark = themeProvider.isSystem &&
                              themeProvider.isDarkMode;
                          bool isDarkModeOn =
                              themeProvider.isDarkMode || systemToggleDark;

                          return CupertinoSwitch(
                            value: isDarkModeOn,
                            activeColor: Colors.yellow,
                            onChanged: (value) async {
                              final provider = Provider.of<ThemeProvider>(
                                  context,
                                  listen: false);
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
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 16,
                        left: 16,
                      ),
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
                      padding: EdgeInsets.only(
                        right: 16,
                        left: 16,
                      ),
                      child: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return CupertinoSwitch(
                            value: themeProvider.isSystem,
                            activeColor: Colors.yellow,
                            onChanged: (value) async {
                              final provider = Provider.of<ThemeProvider>(
                                  context,
                                  listen: false);
                              provider.toggleSystem(value);
                              await provider.saveSettings();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16, bottom: 20),
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
                    controller: _controller,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.yellow : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () async {
                    HapticFeedback.heavyImpact();
                    String inputText = _controller.text;
                    setState(() {
                      globals.preFilledText = inputText;
                      Navigator.pop(context);
                    });
                    print(globals.preFilledText);
                    await saveDefaultMessage();
                    print(globals.preFilledText);
                    print('saved');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}