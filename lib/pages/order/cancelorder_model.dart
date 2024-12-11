// To parse this JSON data, do
//
//     final cancelOrdermodel = cancelOrdermodelFromJson(jsonString);

import 'dart:convert';

CancelOrdermodel cancelOrdermodelFromJson(String str) =>
    CancelOrdermodel.fromJson(json.decode(str));

String cancelOrdermodelToJson(CancelOrdermodel data) =>
    json.encode(data.toJson());

class CancelOrdermodel {
  String status;
  String code;
  String message;

  CancelOrdermodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory CancelOrdermodel.fromJson(Map<String, dynamic> json) =>
      CancelOrdermodel(
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
