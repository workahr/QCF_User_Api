// To parse this JSON data, do
//
//     final removeQtymodel = removeQtymodelFromJson(jsonString);

import 'dart:convert';

RemoveQtymodel removeQtymodelFromJson(String str) =>
    RemoveQtymodel.fromJson(json.decode(str));

String removeQtymodelToJson(RemoveQtymodel data) => json.encode(data.toJson());

class RemoveQtymodel {
  String status;
  String code;
  String message;

  RemoveQtymodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory RemoveQtymodel.fromJson(Map<String, dynamic> json) => RemoveQtymodel(
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
