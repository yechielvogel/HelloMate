import 'package:telephony/telephony.dart';
import 'package:HelloMate/shared/globals.dart';

final SmsSendStatusListener listener = (SendStatus status) {};
final Telephony telephony = Telephony.instance;

Future<void> sendSmsT() async {
  telephony.sendSms(
      to: '$preFilledText',
      message: "Hello mate, it's been a while. How's it going?",
      statusListener: listener);
  if (listener == SmsStatus.STATUS_COMPLETE) {
    smsandroid = '1';
    print("androidTsent");
  } else {
    print("FailedsendSmsT");
  }
}
