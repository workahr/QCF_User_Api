// To parse this JSON data, do
//
//     final updateProfilemodel = updateProfilemodelFromJson(jsonString);

import 'dart:convert';

UpdateProfilemodel updateProfilemodelFromJson(String str) =>
    UpdateProfilemodel.fromJson(json.decode(str));

String updateProfilemodelToJson(UpdateProfilemodel data) =>
    json.encode(data.toJson());

class UpdateProfilemodel {
  String status;
  String code;
  String message;

  UpdateProfilemodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory UpdateProfilemodel.fromJson(Map<String, dynamic> json) =>
      UpdateProfilemodel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
      };
}
