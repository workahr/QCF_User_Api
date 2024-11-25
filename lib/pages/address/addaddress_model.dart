// To parse this JSON data, do
//
//     final addaddressmodel = addaddressmodelFromJson(jsonString);

import 'dart:convert';

Addaddressmodel addaddressmodelFromJson(String str) =>
    Addaddressmodel.fromJson(json.decode(str));

String addaddressmodelToJson(Addaddressmodel data) =>
    json.encode(data.toJson());

class Addaddressmodel {
  String status;
  String code;
  String message;

  Addaddressmodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory Addaddressmodel.fromJson(Map<String, dynamic> json) =>
      Addaddressmodel(
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
