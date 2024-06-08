import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final DateTime? date;
  final String? type;
  final String? message;
  late bool? isMe;

  ChatMessageModel({
    this.date,
    this.type,
    this.message,
    this.isMe = true
  });

  factory ChatMessageModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return ChatMessageModel(
      date: data?['date'],
      type: data?['type'],
      message: data?['message'],
      isMe: data?['isMe'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (date != null) "date": date,
      if (type != null) "type": type,
      if (message != null) "message": message,
      if (isMe != null) "isMe": isMe
    };
  }
}