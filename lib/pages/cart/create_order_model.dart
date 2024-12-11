// To parse this JSON data, do
//
//     final createordermodel = createordermodelFromJson(jsonString);

import 'dart:convert';

Createordermodel createordermodelFromJson(String str) =>
    Createordermodel.fromJson(json.decode(str));

String createordermodelToJson(Createordermodel data) =>
    json.encode(data.toJson());

class Createordermodel {
  String status;
  String code;
  int orderId;
  String message;

  Createordermodel({
    required this.status,
    required this.code,
    required this.orderId,
    required this.message,
  });

  factory Createordermodel.fromJson(Map<String, dynamic> json) =>
      Createordermodel(
        status: json["status"],
        code: json["code"],
        orderId: json["order_id"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "order_id": orderId,
        "message": message,
      };
}
