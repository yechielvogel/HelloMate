import 'package:whatsapp_sender_flutter/whatsapp_sender_flutter.dart';

Future<void> senThroughWhatsapp() async {
  await WhatsAppSenderFlutter.send(
    phones: [
      "447709004207",
    ],
    message: "Hello",
  );
}
