import 'package:background_sms/background_sms.dart';
import 'package:HelloMate/shared/globals.dart';
// import 'package:flutter/material.dart';
// import 'package:HelloMate/main.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:telephony/telephony.dart';
// import 'package:telephony/telephony.dart';

Future<void> sendSms() async {
  String phoneNumber = preFilledText ?? "";
  String message = "Hello mate, it's been a while. How's it going?";

  SmsStatus result = await BackgroundSms.sendMessage(
    phoneNumber: phoneNumber,
    message: message,
  );

  if (result == SmsStatus.sent) {
    smsandroid = '1';
    print("androidsent");
    print(smsandroid);
  } else {
    print("Failed");
  }
}

// final SmsSendStatusListener listener = (SendStatus status) {
// 	};
	
// void sendSmsT() {
// 	to: "1234567890";
// 	message: "May the force be with you!";
// 	statusListener: listener;
// }
	

// Future<void> smsAndroid() async {
//   String? address = randomContactNumber;

//   SmsMessage message =
//       SmsMessage(address, "Hello mate, it's been a while. How's it going?");
//   message.onStateChanged.listen((state) {
//     if (state == SmsMessageState.Sent) {
//       smsandroid = '1';
//       print("SMS is sent!");
//     }
//   });

//   // Create an instance of SmsSender
//   SmsSender sender = SmsSender();

//   // Send the SMS message
//   sender.sendSms(message);
// }
