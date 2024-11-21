// To parse this JSON data, do
//
//     final dashboardlistmodel = dashboardlistmodelFromJson(jsonString);

import 'dart:convert';

SelectLocationModel selectlocationmodelFromJson(String str) =>
    SelectLocationModel.fromJson(json.decode(str));

String selectlocationmodelToJson(SelectLocationModel data) =>
    json.encode(data.toJson());

class SelectLocationModel {
  String status;
  List<locations> list;
  String code;
  String message;

  SelectLocationModel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory SelectLocationModel.fromJson(Map<String, dynamic> json) =>
      SelectLocationModel(
        status: json["status"],
        list: List<locations>.from(
            json["list"].map((x) => locations.fromJson(x))),
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

class locations {
  int id;
  String icon;
  String type;
  String address;

  int status;
  int active;
  int createdBy;
  dynamic createdDate;
  int updatedBy;
  dynamic updatedDate;

  locations({
    required this.id,
    required this.icon,
    required this.type,
    required this.address,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory locations.fromJson(Map<String, dynamic> json) => locations(
        id: json["id"],
        icon: json["icon"],
        type: json["type"],
        address: json["address"],
        status: json["status"],
        active: json["active"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "type": type,
        "address": address,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
