import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'globals.dart' as globals;

Future<void> onShare(BuildContext context) async {
  final box = context.findRenderObject() as RenderBox?;

  if (box != null && box.hasSize) {
    final topLeft = box.localToGlobal(Offset.zero);
    final bottomRight = box.localToGlobal(box.size.bottomRight(Offset.zero));
    final rect = Rect.fromPoints(topLeft, bottomRight);

    await Share.share(
      'I used HelloMate to reach out to a old friend! it took me ${globals.retakeNumber}${globals.textAgain}! I challenge you https://apps.apple.com/gb/app//idid6449648643',
      subject: 'HelloMate',
      sharePositionOrigin: rect,
    );
  } else {}
}

void retakeTry() {
  if (globals.retakeNumber == '1') {
    globals.textAgain = ' try';
  } else {
    globals.textAgain = ' trys';
  }
}
// https://itunes.apple.com/idhttps://itunes.apple.com/id6449648643