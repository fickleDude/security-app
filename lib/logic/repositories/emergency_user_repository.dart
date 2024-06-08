import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safety_app/domain/emergency_user_model.dart';
import '../../domain/emergency_contact_model.dart';

abstract class UserRepository {
  Stream<List<EmergencyUser>> getUsers();

  void addUser(EmergencyUser contact);
  void deleteUser(EmergencyUser contact);
  void updateUser(EmergencyUser contact);
}

class EmergencyUserRepository implements UserRepository {
  final String uid;
  EmergencyUserRepository({required this.uid});

  @override
  Stream<List<EmergencyUser>> getUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where(
        'id',
        isNotEqualTo: uid
        )
        .snapshots()
        .map((snapshot) =>
        snapshot
            .docs
            .map((document) => EmergencyUser
            .fromFirestore(document, null)
        )
            .toList()
    );
  }

  @override
  Future<void> addUser(EmergencyUser user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .withConverter(
      fromFirestore: EmergencyUser.fromFirestore,
      toFirestore: (EmergencyUser user, options) => user.toFirestore(),
    )
        .doc(uid)
        .set(user);
  }

  @override
  Future<void> deleteUser(EmergencyUser contact) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .delete();
  }

  @override
  void updateUser(EmergencyUser contact) {
    // TODO: implement updateUser
  }
}