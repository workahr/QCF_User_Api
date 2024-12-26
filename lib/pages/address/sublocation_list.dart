// To parse this JSON data, do
//
//     final subLocationListmodel = subLocationListmodelFromJson(jsonString);

import 'dart:convert';

SubLocationListmodel subLocationListmodelFromJson(String str) =>
    SubLocationListmodel.fromJson(json.decode(str));

String subLocationListmodelToJson(SubLocationListmodel data) =>
    json.encode(data.toJson());

class SubLocationListmodel {
  String status;
  List<SubLocation> list;
  String code;
  String message;

  SubLocationListmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory SubLocationListmodel.fromJson(Map<String, dynamic> json) =>
      SubLocationListmodel(
        status: json["status"],
        list: List<SubLocation>.from(
            json["list"].map((x) => SubLocation.fromJson(x))),
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

class SubLocation {
  int id;
  String name;
  int serial;
  int mainLocationId;
  String price;
  int status;
  int createdBy;
  DateTime createdDate;
  dynamic updatedBy;
  dynamic updatedDate;

  SubLocation({
    required this.id,
    required this.name,
    required this.serial,
    required this.mainLocationId,
    required this.price,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory SubLocation.fromJson(Map<String, dynamic> json) => SubLocation(
        id: json["id"],
        name: json["name"],
        serial: json["serial"],
        mainLocationId: json["main_location_id"],
        price: json["price"],
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
        "main_location_id": mainLocationId,
        "price": price,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
