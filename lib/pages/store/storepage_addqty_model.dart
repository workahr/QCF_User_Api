// To parse this JSON data, do
//
//     final addQtymodel = addQtymodelFromJson(jsonString);

import 'dart:convert';

AddQtymodel addQtymodelFromJson(String str) =>
    AddQtymodel.fromJson(json.decode(str));

String addQtymodelToJson(AddQtymodel data) => json.encode(data.toJson());

class AddQtymodel {
  String status;
  String code;
  String message;

  AddQtymodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory AddQtymodel.fromJson(Map<String, dynamic> json) => AddQtymodel(
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
