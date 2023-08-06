import 'package:telephony/telephony.dart';
import 'package:HelloMate/globals.dart';

final SmsSendStatusListener listener = (SendStatus status) {};
final Telephony telephony = Telephony.instance;

Future<void> sendSmsT() async {
  telephony.sendSms(
      to: '$randomContactNumber',
      message: "Hello mate, it's been a while. How's it going?",
      statusListener: listener);
  if (listener == SmsStatus.STATUS_COMPLETE) {
    smsandroid = '1';
    print("androidTsent");
  } else {
    print("Failed");
  }
}
