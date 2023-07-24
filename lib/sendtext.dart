import 'package:flutter_sms/flutter_sms.dart';
import 'globals.dart' as globals;

Future<bool> _sendSMS(String message, List<String> recipients) async {
  try {
    await sendSMS(message: message, recipients: recipients);
    return true; // SMS is sent successfully
  } catch (error) {
    print("Error occurred: $error");
    return false; // SMS sending failed
  }
}

Future<void> sendText() async {
  String message = "";
  List<String> recipients = [
    globals.textAgain ?? '',
  ];

  bool isSent = await _sendSMS(message, recipients);

  if (isSent) {
    // Run your specific function here
    runCertainFunction();
  } else {
    // SMS sending failed, handle accordingly
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
