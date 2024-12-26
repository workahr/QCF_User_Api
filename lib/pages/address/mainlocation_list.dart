// To parse this JSON data, do
//
//     final mainLocationListmodel = mainLocationListmodelFromJson(jsonString);

import 'dart:convert';

MainLocationListmodel mainLocationListmodelFromJson(String str) =>
    MainLocationListmodel.fromJson(json.decode(str));

String mainLocationListmodelToJson(MainLocationListmodel data) =>
    json.encode(data.toJson());

class MainLocationListmodel {
  String status;
  List<MainLocation> list;
  String code;
  String message;

  MainLocationListmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory MainLocationListmodel.fromJson(Map<String, dynamic> json) =>
      MainLocationListmodel(
        status: json["status"],
        list: List<MainLocation>.from(
            json["list"].map((x) => MainLocation.fromJson(x))),
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "code": code,
        "message": message,
      };
}

class MainLocation {
  int id;
  String? name;
  int? serial;
  int? status;
  int? createdBy;
  DateTime createdDate;
  dynamic updatedBy;
  dynamic updatedDate;

  MainLocation({
    required this.id,
    this.name,
    this.serial,
    this.status,
    this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory MainLocation.fromJson(Map<String, dynamic> json) => MainLocation(
        id: json["id"],
        name: json["name"],
        serial: json["serial"],
        status: json["status"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "serial": serial,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
