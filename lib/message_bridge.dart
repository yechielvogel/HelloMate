import 'package:HelloMate/globals.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class MessageBridge {
  static const MethodChannel messageChannel =
      MethodChannel('yechielvogel.com/sendmessage');

  static String _resultCode = '';

  static Future<String> sendmessage() async {
    final arguments = {'name': randomContactNumber};

    final result = Completer<String>();
    messageChannel.setMethodCallHandler((call) async {
      if (call.method == "messageComposeResult") {
        _resultCode = call.arguments as String;
        print(randomContactNumber);
        print(_resultCode);

        result.complete(_resultCode);
      }
    });

    await messageChannel.invokeMethod(
      'messageComposeViewController',
      arguments,
    );

    return result.future;
  }

  static String get resultCode => _resultCode;
}
