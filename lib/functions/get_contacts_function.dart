import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
import 'dart:math';
import '../models/contact_info_model.dart';



Future<ContactInfo> getRandomContact() async {
  Iterable<Contact> contacts = await ContactsService.getContacts(
    withThumbnails: true,
  );

  List<Contact> contactList = contacts.toList();

  if (contactList.isEmpty) {
    return ContactInfo(
      name: '',
      phoneNumber: '',
    );
  }

  List<ContactInfo> filteredContacts = [];

  for (var randomContact in contactList) {
    if (randomContact.familyName?.isEmpty ?? true) {
      print('nolastname');
      continue; // Skip contacts without a last name
    } else if (containsEmoji(randomContact.displayName ?? '')) {
      print('hasemoji');
      continue; // Skip contacts without a last name
    }

    String contactName = randomContact.displayName ?? '';
    String contactPhoneNumber = '';
    String? contactProfilePic;

    if (randomContact.phones != null && randomContact.phones!.isNotEmpty) {
      contactPhoneNumber = randomContact.phones!.first.value ?? '';
    }

    if (randomContact.avatar != null && randomContact.avatar!.isNotEmpty) {
      contactProfilePic = base64Encode(randomContact.avatar!);
    }

    filteredContacts.add(ContactInfo(
      name: contactName,
      phoneNumber: contactPhoneNumber,
      profilePic: contactProfilePic,
    ));
  }

  if (filteredContacts.isEmpty) {
    return ContactInfo(
      name: '',
      phoneNumber: '',
    );
  }

  final randomIndex = Random().nextInt(filteredContacts.length);
  return filteredContacts[randomIndex];
}

bool containsEmoji(String text) {
// maybe only check for like heart emojis and stuff like that.
  return text.runes.any((rune) {
    return (rune >= 0x1F600 && rune <= 0x1F64F) ||
        (rune >= 0x1F300 && rune <= 0x1F5FF) ||
        (rune >= 0x1F680 && rune <= 0x1F6FF) ||
        (rune >= 0x1F700 && rune <= 0x1F77F) ||
        (rune >= 0x1F780 && rune <= 0x1F7FF) ||
        (rune >= 0x1F800 && rune <= 0x1F8FF) ||
        (rune >= 0x1F900 && rune <= 0x1F9FF) ||
        (rune >= 0x1FA00 && rune <= 0x1FA6F);
  });
}
