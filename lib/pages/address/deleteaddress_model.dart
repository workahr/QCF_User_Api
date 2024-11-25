// To parse this JSON data, do
//
//     final deleteaddressmodel = deleteaddressmodelFromJson(jsonString);

import 'dart:convert';

Deleteaddressmodel deleteaddressmodelFromJson(String str) =>
    Deleteaddressmodel.fromJson(json.decode(str));

String deleteaddressmodelToJson(Deleteaddressmodel data) =>
    json.encode(data.toJson());

class Deleteaddressmodel {
  String status;
  String code;
  String message;

  Deleteaddressmodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory Deleteaddressmodel.fromJson(Map<String, dynamic> json) =>
      Deleteaddressmodel(
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
