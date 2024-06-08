
import 'dart:convert';

class ChatRecipientModel {
  final String? id;
  final String? name;
  final String? email;

  const ChatRecipientModel({
    this.id,
    this.name,
    this.email
  });

  factory ChatRecipientModel.fromMap(Map<String, dynamic> json) => ChatRecipientModel(
      id: json['id'],
      name: json['name'],
      email: json['email']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email
  };

  static ChatRecipientModel userFromJson(String str) {
    final jsonData = json.decode(str);
    return ChatRecipientModel.fromMap(jsonData);
  }

  static String userToJson(ChatRecipientModel data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }
}