// To parse this JSON data, do
//
//     final addQuantityModel = addQuantityModelFromJson(jsonString);

import 'dart:convert';

AddQuantityModel addQuantityModelFromJson(String str) => AddQuantityModel.fromJson(json.decode(str));

String addQuantityModelToJson(AddQuantityModel data) => json.encode(data.toJson());

class AddQuantityModel {
    String status;
    String code;
    String message;

    AddQuantityModel({
        required this.status,
        required this.code,
        required this.message,
    });

    factory AddQuantityModel.fromJson(Map<String, dynamic> json) => AddQuantityModel(
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
