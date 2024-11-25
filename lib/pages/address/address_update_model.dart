// To parse this JSON data, do
//
//     final adddressUpdatemodel = adddressUpdatemodelFromJson(jsonString);

import 'dart:convert';

AdddressUpdatemodel adddressUpdatemodelFromJson(String str) =>
    AdddressUpdatemodel.fromJson(json.decode(str));

String adddressUpdatemodelToJson(AdddressUpdatemodel data) =>
    json.encode(data.toJson());

class AdddressUpdatemodel {
  String status;
  String code;
  String message;

  AdddressUpdatemodel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory AdddressUpdatemodel.fromJson(Map<String, dynamic> json) =>
      AdddressUpdatemodel(
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
