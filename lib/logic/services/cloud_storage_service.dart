import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safety_app/logic/models/chat_message_model.dart';

class CloudService {

  CloudService._();
  static final CloudService cloud = CloudService._();

  //use _ for private variables
  static final FirebaseFirestore _cloudInstance = FirebaseFirestore.instance;

  //MANAGE USERS
  Future<void> addUser(Map<String, dynamic> user) async{
    await _cloudInstance.collection('users').doc(user["id"]).set(user);
  }

  Future<void> deleteUser(Map<String, dynamic> user) async{
    await _cloudInstance.collection('users').doc(user["id"]).delete();
  }

  Future<void> updateUser(Map<String, dynamic> user) async{
    await _cloudInstance.collection('users').doc(user["id"]).update({
    'name': user["name"],
    'email': user["email"]
    });
  }

  //CHAT
  Future<void> sendMessage(String userId, String recipientId,ChatMessageModel message) async{
    final sendDocRef = _cloudInstance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(recipientId)
        .collection('messages')
        .withConverter(
      fromFirestore: ChatMessageModel.fromFirestore,
      toFirestore: (ChatMessageModel messageModel, options) => messageModel.toFirestore(),
    ).doc(message.date.toString());
    final getDocRef = _cloudInstance
        .collection('users')
        .doc(recipientId)
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .withConverter(
      fromFirestore: ChatMessageModel.fromFirestore,
      toFirestore: (ChatMessageModel messageModel, options) => messageModel.toFirestore(),
    ).doc(message.date.toString());
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(sendDocRef, message);
      message.isMe = false;
      transaction.set(getDocRef, message);
    });
  }

  Future<void> deleteMessage(String userId, String recipientId, String messageId) async{
    final sendDocRef = _cloudInstance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(recipientId)
        .collection('messages')
        .doc(messageId);
    final getDocRef = _cloudInstance
        .collection('users')
        .doc(recipientId)
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .doc(messageId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.delete(sendDocRef);
      transaction.delete(getDocRef);
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
        .collection('chats')
        .doc(recipientId)
        .collection('messages')
        .orderBy('date', descending: false)
        .snapshots();
  }
}