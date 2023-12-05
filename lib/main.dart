import 'package:HelloMate/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'Themes/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadSettings();
  await getContacts();
  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          SystemChrome.setSystemUIOverlayStyle(
            _getSystemUIOverlayStyle(themeProvider),
          );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: Scaffold(
              body: Home(),
            ),
          );
        },
      ),
    ),
  );
  WidgetsBinding.instance.addObserver(
    AppLifecycleObserver(themeProvider: themeProvider),
  );
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  final ThemeProvider themeProvider;

  AppLifecycleObserver({required this.themeProvider});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      themeProvider.saveSettings();
    }
  }
}

SystemUiOverlayStyle _getSystemUIOverlayStyle(ThemeProvider themeProvider) {
  if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark ||
      themeProvider.isDarkMode) {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );
  }

  return const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
}

