import 'package:flutter/material.dart';
import 'package:HelloMate/shared/globals.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: SpinKitRing(
          color: Colors.yellow,
          size: 50.0,
        ),
      ),
    );
  }
}