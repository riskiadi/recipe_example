// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.value,
    this.message,
    this.userId,
    this.email,
    this.username,
  });

  final int value;
  final String message;
  final String userId;
  final String email;
  final String username;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    value: json["value"],
    message: json["message"],
    userId: json["user_id"],
    email: json["email"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "user_id": userId,
    "email": email,
    "username": username,
  };
}
