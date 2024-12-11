// To parse this JSON data, do
//
//     final deleteCartmodel = deleteCartmodelFromJson(jsonString);

import 'dart:convert';

DeleteCartmodel deleteCartmodelFromJson(String str) =>
    DeleteCartmodel.fromJson(json.decode(str));

String deleteCartmodelToJson(DeleteCartmodel data) =>
    json.encode(data.toJson());

class DeleteCartmodel {
  String status;
  String code;
  String message;

  DeleteCartmodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory DeleteCartmodel.fromJson(Map<String, dynamic> json) =>
      DeleteCartmodel(
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
