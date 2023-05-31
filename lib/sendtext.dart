import 'package:flutter_sms/flutter_sms.dart';
// import 'package:sms_advanced/sms_advanced.dart';
import 'globals.dart' as globals;

// test code try to add if sent fun the tilewidget function else
// dont run that function. bellow is example code that might do that.

void _sendSMS(String message, List<String> recipients) async {
  String result = await sendSMS(message: message, recipients: recipients)
      .catchError((onError) {
    return "Error occurred";
  });

  (result);
}

Future<void> sendText() async {
  String message = "Hello mate, it's been a while. How's it going?";

  List<String> recipients = [
    globals.randomContactNumber ?? '',
  ];

  _sendSMS(message, recipients);
}

// Future<void> _sendSMS(String message, List<String> recipients) async {
//   SmsSender sender = SmsSender();
//   SmsMessage smsMessage = SmsMessage(message, recipients[0]);

//   smsMessage.onStateChanged.listen((state) {
//     if (state == SmsMessageState.Sent) {
//       print("SMS is sent!");
//     } else if (state == SmsMessageState.Delivered) {
//       print("SMS is delivered!");
//     }
//   });

//   await sender.sendSms(smsMessage);
// }

// Future<void> sendText() async {
//   String message = "Hello mate, it's been a while. How's it going?";
//   List<String> recipients = [
//     globals.randomContactNumber ?? '',
//   ];

//   await _sendSMS(message, recipients);
// }

// void _sendSMS(String message, List<String> recipients) async {
//   SmsSender sender = SmsSender();
//   SmsMessage smsMessage = SmsMessage(message, recipients[0]);

//   try {
//     await sender.sendSms(smsMessage);
//     print("SMS sent successfully!");
//   } catch (error) {
//     print("Failed to send SMS: $error");
//   }
// }

// Future<void> sendText() async {
//   String message = "Hello mate, it's been a while. How's it going?";
//   List<String> recipients = [
//     globals.randomContactNumber ?? '',
//   ];

//   _sendSMS(message, recipients);
// }









// void _sendSMS(String message, List<String> recipients) async {
//   String result = await sendSMS(message: message, recipients: recipients);
//   message.onStateChanged.listen((state) {
//   if (state == SmsMessageState.Sent) {
//       print("SMS is sent!");
//     }}
//       .catchError((onError) {
//     return "Error occurred";
//   }));

//   (result);
// }

// Future<void> sendText() async {
//   String message = "Hello mate, it's been a while. How's it going?";
//   List<String> recipients = [
//     globals.randomContactNumber ?? '',
//   ];

//   _sendSMS(message, recipients);
// }