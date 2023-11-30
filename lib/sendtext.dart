import 'package:flutter_sms/flutter_sms.dart';
import 'package:HelloMate/shared/globals.dart' as globals;

Future<bool> _sendSMS(String message, List<String> recipients) async {
  try {
    await sendSMS(message: message, recipients: recipients);
    return true;
  } catch (error) {
    print("Error occurred: $error");
    return false;
  }
}

Future<void> sendText() async {
  String message = "";
  List<String> recipients = [
    globals.textAgain ?? '',
  ];

  bool isSent = await _sendSMS(message, recipients);

  if (isSent) {
    runCertainFunction();
  } else {
    handleSendingFailed();
  }
}

void runCertainFunction() {
  print('sent');
}

void handleSendingFailed() {
  print('did not send');
  print(globals.textAgain);
}
