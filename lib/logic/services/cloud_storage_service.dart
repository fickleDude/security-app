import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {

  CloudService._();
  static final CloudService cloud = CloudService._();

  //use _ for private variables
  static final FirebaseFirestore _cloudInstance = FirebaseFirestore.instance;

  Future<void> addUser(Map<String, dynamic> user) async{
    await _cloudInstance.collection('users').doc(user["id"]).set(user);
  }

  Future<void> updateUser(Map<String, dynamic> user) async{
    await _cloudInstance.collection('users').doc(user["id"]).update({
    'name': user["name"],
    'email': user["email"]
    });
  }

  Future<void> sendMessage(String userId, String recipientId,
      String message, String type) async{
    await _cloudInstance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .doc(recipientId)
        .collection('chats')
        .add({
      'type': type,
      'senderId': userId,
      'receiverId': recipientId,
      'message': message,
      'date': DateTime.now(),
    });
    await _cloudInstance
        .collection('users')
        .doc(recipientId)
        .collection('messages')
        .doc(userId)
        .collection('chats')
        .add({
      'type': type,
      'senderId': userId,
      'receiverId': recipientId,
      'message': message,
      'date': DateTime.now(),
    });
  }


  Stream<QuerySnapshot<Map<String, dynamic>>>? getRecipients(String? userEmail){
    return _cloudInstance.collection('users')
              .where(
              'email',
              isNotEqualTo: userEmail ?? ""
          )
          .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String userId, String recipientId){
    return _cloudInstance.collection('users')
        .doc(userId)
        .collection('messages')
        .doc(recipientId)
        .collection('chats')
        .orderBy('date', descending: false)
        .snapshots();
  }
}