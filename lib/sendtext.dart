import 'package:flutter_sms/flutter_sms.dart';
// import 'package:sms_advanced/sms_advanced.dart';
import 'globals.dart' as globals;

// test code try to add if sent fun the tilewidget function else
// dont run that function. bellow is example code that might do that.

// void _sendSMS(String message, List<String> recipients) async {
//   String result = await sendSMS(message: message, recipients: recipients)
//       .catchError((onError) {
//     return "Error occurred";
//   });

//   (result);
// }

// Future<void> sendText() async {
//   String message = "Hello mate, it's been a while. How's it going?";

//   List<String> recipients = [
//     globals.randomContactNumber ?? '',
//   ];

//   _sendSMS(message, recipients);
// }

// new code main!

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

// new code

// Future<bool> _sendSMS(String message, List<String> recipients) async {
//   SmsSender sender = SmsSender();
//   SmsMessage messagee = SmsMessage(message, recipients[0]);
//   bool isSent = false;

//   messagee.onStateChanged.listen((SmsMessageState state) {
//     if (state == SmsMessageState.Sent) {
//       print("SMS is sent!");
//       isSent = true;
//     } else if (state == SmsMessageState.Fail) {
//       print("SMS sending failed!");
//       isSent = false;
//     }
//   });

//   sender.sendSms(messagee);
//   return isSent;
// }

// Future<void> sendText() async {
//   String message = "Hello mate, it's been a while. How's it going?";
//   List<String> recipients = [
//     globals.randomContactNumber ?? '',
//   ];

//   bool isSent = await _sendSMS(message, recipients);

//   if (isSent) {
//     // Run your specific function here
//     print('sent');
//   } else {
//     // SMS sending failed, handle accordingly
//     print('did not send');
//   }
// }

// void runCertainFunction() {
//   // Code for the specific function to run when SMS is sent
// }

// void handleSendingFailed() {
//   // Code for handling SMS sending failure
// }

// new code

// this code bellow should work and see if user sent the message but there is
// somethhing wrong with the package its self not sure took a screenshot of the
// error

// import 'package:sms_advanced/sms_advanced.dart';

// Future<void> sendText() async {
//   SmsSender sender = SmsSender();
//   String address = globals.randomContactNumber ?? '';
//   ;
//   SmsMessage message =
//        SmsMessage(address, "Hello mate, it's been a while. How's it going?");
//   message.onStateChanged.listen((state) {
//     if (state == SmsMessageState.Sent) {
//       print("SMS is sent!");
//     }
//   });
//   sender.sendSms(message);
// }

// new code

// Future<void> sendText() async {
//   SmsSender sender = SmsSender();
//   String address = globals.randomContactNumber ?? '';

//   sender.sendSms(
//       SmsMessage(address, "Hello mate, it's been a while. How's it going?"));
// }
