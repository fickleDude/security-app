import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/contact_model.dart';

abstract class ContactRepository {
  Stream<List<EmergencyContact>> getContacts();

  void addContact(EmergencyContact contact);
  void deleteContact(EmergencyContact contact);
  void updateContact(EmergencyContact contact);
}

class EmergencyContactRepository implements ContactRepository {
  final String uid;
  EmergencyContactRepository({required this.uid});

  @override
  Stream<List<EmergencyContact>> getContacts() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .snapshots()
        .map((snapshot) =>
        snapshot
            .docs
            .map((document) => EmergencyContact
            .fromFirestore(document, null)
        )
            .toList()
    );
  }

  @override
  Future<void> addContact(EmergencyContact contact) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .withConverter(
      fromFirestore: EmergencyContact.fromFirestore,
      toFirestore: (EmergencyContact contact, options) => contact.toFirestore(),
    )
        .doc(contact.number)
        .set(contact);
  }

  @override
  Future<void> deleteContact(EmergencyContact contact) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .doc(contact.number)
        .delete();
  }

  @override
  Future<void> updateContact(EmergencyContact contact) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .doc(contact.number)
        .update({
      'number': contact.number,
      'name': contact.name
    });
  }
}