// import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

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

  return ContactInfo(
    name: contactName,
    phoneNumber: contactPhoneNumber,
  );
}
