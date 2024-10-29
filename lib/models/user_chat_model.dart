// To parse this JSON data, do
//
//     final userCart = userCartFromJson(jsonString);

import 'dart:convert';

List<UserChat> userChatFromJson(String str) =>
    List<UserChat>.from(json.decode(str).map((x) => UserChat.fromJson(x)));

String userChatToJson(List<UserChat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserChat {
  final String id;
  final CustomerId customerId;

  UserChat({
    required this.id,
    required this.customerId,
  });

  factory UserChat.fromJson(Map<String, dynamic> json) => UserChat(
        id: json["_id"],
        customerId: CustomerId.fromJson(json["customerId"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "customerId": customerId.toJson(),
      };
}

class CustomerId {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String profile;
  final String userType;

  CustomerId({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.profile,
    required this.userType,
  });

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
      id: json["_id"],
      username: json["username"],
      email: json["email"],
      phone: json["phone"],
      profile: json["profile"],
      userType: json["userType"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "phone": phone,
        "profile": profile,
        "userType": userType,
      };
}
