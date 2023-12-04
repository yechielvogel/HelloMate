import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:HelloMate/shared/globals.dart' as globals;

String iosLink = 'https://apps.apple.com/gb/app//idid6449648643';
String androidLink =
    'https://play.google.com/store/apps/details?id=com.Yechiel.HelloMate';

Future<void> onShare(BuildContext context) async {
  final box = context.findRenderObject() as RenderBox?;

  if (box != null && box.hasSize) {
    final topLeft = box.localToGlobal(Offset.zero);
    final bottomRight = box.localToGlobal(box.size.bottomRight(Offset.zero));
    final rect = Rect.fromPoints(topLeft, bottomRight);
    if (Platform.isIOS) {
      await Share.share(
        'I used HelloMate to reach out to a friend! It took me ${globals.retakeNumber}${globals.textAgain}! Try it yourself. $iosLink',
        subject: 'HelloMate',
        sharePositionOrigin: rect,
      );
    } else if (Platform.isAndroid) {
      await Share.share(
        'I used HelloMate to reach out to a friend! It took me ${globals.retakeNumber}${globals.textAgain}! Try it yourself. $androidLink',
        subject: 'HelloMate',
        sharePositionOrigin: rect,
      );
    } else {}
  }
}

void retakeTry() {
  if (globals.retakeNumber == '1') {
    globals.textAgain = ' try';
  } else {
    globals.textAgain = ' tries';
  }
}
// I challenge you!
// Try it yourself
// https://itunes.apple.com/idhttps://itunes.apple.com/id6449648643