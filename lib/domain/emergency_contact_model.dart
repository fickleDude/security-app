import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyContact {
  String? number;
  String? name;

  EmergencyContact({this.number, this.name});

  factory EmergencyContact.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return EmergencyContact(
      number: data?['number'],
      name: data?['name']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (number != null) "number": number,
      if (name != null) "name": name
    };
  }
}