// import 'package:flutter/material.dart';
import 'dart:convert';
// import 'dart:js_interop';

import 'package:contacts_service/contacts_service.dart';
import 'dart:math';

class ContactInfo {
  String name;
  String phoneNumber;
  String? profilePic;

  ContactInfo({required this.name, required this.phoneNumber, this.profilePic});
}

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

  final randomIndex = Random().nextInt(contactList.length);
  final randomContact = contactList[randomIndex];

  String contactName = randomContact.displayName ?? '';
  String contactPhoneNumber = '';
  String? contactProfilePic;

  if (randomContact.phones != null && randomContact.phones!.isNotEmpty) {
    contactPhoneNumber = randomContact.phones!.first.value ?? '';
  }

  if (randomContact.avatar != null && randomContact.avatar!.isNotEmpty) {
    contactProfilePic = base64Encode(randomContact.avatar!);
  }
  // this code is a test to see if i could remove any contacts with only first name.
  // if (randomContact.familyName!.isEmpty) {
  //   contactList.removeLast();
  //   print('nolastname');
  // }

  return ContactInfo(
    name: contactName,
    phoneNumber: contactPhoneNumber,
    profilePic: contactProfilePic,
  );
}
