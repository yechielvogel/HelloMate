// import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

// List<Contact> contactList = [];

// Future<void> fetchContacts() async {
//   try {
//     Iterable<Contact> contacts = await ContactsService.getContacts();
//     contactList = contacts.toList();
//   } catch (e) {
//     print('Error fetching contacts: $e');
//   }
// }

// String getRandomContactName() {
//   if (contactList.isEmpty) {
//     return '';
//   }

//   final randomIndex = Random().nextInt(contactList.length);
//   final randomContact = contactList[randomIndex];

//   return randomContact.displayName ?? 'hello';
// }

// String? getRandomContactNumber() {
//   if (contactList.isEmpty) {
//     return null;
//   }

//   final randomIndex = Random().nextInt(contactList.length);
//   final randomContact = contactList[randomIndex];

//   if (randomContact.phones != null && randomContact.phones!.isNotEmpty) {
//     return randomContact.phones!.first.value ?? '';
//   } else {
//     return null;
//   }
// }

class ContactInfo {
  String name;
  String phoneNumber;

  ContactInfo({required this.name, required this.phoneNumber});
}

Future<ContactInfo> getRandomContact() async {
  Iterable<Contact> contacts = await ContactsService.getContacts();
  List<Contact> contactList = contacts.toList();

  if (contactList.isEmpty) {
    return ContactInfo(name: '', phoneNumber: '');
  }

  final randomIndex = Random().nextInt(contactList.length);
  final randomContact = contactList[randomIndex];

  String contactName = randomContact.displayName ?? '';
  String contactPhoneNumber = '';

  if (randomContact.phones != null && randomContact.phones!.isNotEmpty) {
    contactPhoneNumber = randomContact.phones!.first.value ?? '';
  }

  return ContactInfo(name: contactName, phoneNumber: contactPhoneNumber);
}
