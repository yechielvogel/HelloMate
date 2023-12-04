import 'package:telephony/telephony.dart';
import 'package:HelloMate/shared/globals.dart';

final SmsSendStatusListener listener = (SendStatus status) {};
final Telephony telephony = Telephony.instance;

Future<void> sendSmsT() async {
  try {
    await telephony.sendSms(
        // this is just for testing make sure to change back.
        // to: '13477704206',

        to: '$randomContactNumber',
        message: "$preFilledText",
        statusListener: listener);

    if (listener == SmsStatus.STATUS_COMPLETE) {
      // smsandroid = '1';
      print("androidTsent");
    } else if (listener == SmsStatus.STATUS_NONE) {
      print("status none");
      print("FailedsendSmsT");
    } else if (listener == SmsStatus.STATUS_PENDING) {
      print("status pending");
      print("FailedsendSmsT");
    } else if (listener == SmsStatus.STATUS_FAILED) {
      print("status failed");
      print("FailedsendSmsT");
    } else
      print('sms failed with out status');
  } catch (e) {
    print("Error sending SMS: $e");
    // Handle the error here
  }
}
