import 'package:flutter/material.dart';
import 'package:HelloMate/shared/globals.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
 bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: SpinKitRing(
          color: isDarkMode(context) ? Colors.yellow : Colors.black,
          size: 50.0,
        ),
      ),
    );
  }
}
