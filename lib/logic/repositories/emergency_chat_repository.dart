import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/chat_message_model.dart';

abstract class ChatRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRecipients();
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String recipientId);

  void sendMessage(String recipientId,ChatMessageModel message);
  void deleteMessage(String recipientId, String messageId);
}

class EmergencyChatRepository implements ChatRepository{
  final User user;

  EmergencyChatRepository({required this.user});

  @override
  void deleteMessage(String recipientId, String messageId) async{
    String uid = user.uid;
    final sendDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(recipientId)
        .collection('messages')
        .doc(messageId);
    final getDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(recipientId)
        .collection('chats')
        .doc(uid)
        .collection('messages')
        .doc(messageId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.delete(sendDocRef);
      transaction.delete(getDocRef);
    });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String recipientId) {
    return FirebaseFirestore.instance.collection('users')
        .doc(user.uid)
        .collection('chats')
        .doc(recipientId)
        .collection('messages')
        .orderBy('date', descending: false)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRecipients() {
    return FirebaseFirestore.instance.collection('users')
        .where(
        'email',
        isNotEqualTo: user.email ?? ""
    )
        .snapshots();
  }

  @override
  void sendMessage(String recipientId, ChatMessageModel message) {
    String uid = user.uid;
    final sendDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(recipientId)
        .collection('messages')
        .withConverter(
      fromFirestore: ChatMessageModel.fromFirestore,
      toFirestore: (ChatMessageModel messageModel, options) => messageModel.toFirestore(),
    ).doc(message.date.toString());
    final getDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(recipientId)
        .collection('chats')
        .doc(uid)
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
}