// To parse this JSON data, do
//
//     final loginOtpModel = loginOtpModelFromJson(jsonString);

import 'dart:convert';

LoginOtpModel loginOtpModelFromJson(String str) =>
    LoginOtpModel.fromJson(json.decode(str));

String loginOtpModelToJson(LoginOtpModel data) => json.encode(data.toJson());

class LoginOtpModel {
  String code;
  String status;
  int? otp;
  String? authToken;
  String message;

  LoginOtpModel({
    required this.code,
    required this.status,
    this.otp,
    this.authToken,
    required this.message,
  });

  factory LoginOtpModel.fromJson(Map<String, dynamic> json) => LoginOtpModel(
        code: json["code"],
        status: json["status"],
        otp: json["otp"],
        authToken: json["auth_token"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "otp": otp,
        "auth_token": authToken,
        "message": message,
      };
}








// To parse this JSON data, do
//
//     final loginOtpModel = loginOtpModelFromJson(jsonString);

// import 'dart:convert';

// LoginOtpModel loginOtpModelFromJson(String str) =>
//     LoginOtpModel.fromJson(json.decode(str));

// String loginOtpModelToJson(LoginOtpModel data) => json.encode(data.toJson());

// class LoginOtpModel {
//   String status;
//   String code;
//   int? otp;
//   String message;
//   String? authToken;

//   LoginOtpModel(
//       {required this.status,
//       required this.code,
//       this.otp,
//       required this.message,
//       this.authToken});

//   factory LoginOtpModel.fromJson(Map<String, dynamic> json) => LoginOtpModel(
//       status: json["status"],
//       code: json["code"],
//       otp: json["otp"],
//       message: json["message"],
//       authToken: json["auth_token"]);

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "code": code,
//         "otp": otp,
//         "message": message,
//         "auth_token": authToken
//       };
//}
