
import 'dart:convert';

class AppUserModel {
  final String? id;
  final String? name;
  final String? email;

  const AppUserModel({
    this.id,
    this.name,
    this.email
  });

  factory AppUserModel.fromMap(Map<String, dynamic> json) => AppUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email
  };

  static AppUserModel userFromJson(String str) {
    final jsonData = json.decode(str);
    return AppUserModel.fromMap(jsonData);
  }

  static String userToJson(AppUserModel data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }
}