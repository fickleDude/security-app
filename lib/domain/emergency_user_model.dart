import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyUser {
  String? id;
  String? name;
  String? email;

  EmergencyUser({this.id, this.name, this.email});

  factory EmergencyUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return EmergencyUser(
        id: data?['id'],
        name: data?['name'],
        email: data?['email'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (email != null) "email": email
    };
  }
}