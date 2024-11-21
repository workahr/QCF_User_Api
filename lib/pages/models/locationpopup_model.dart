// To parse this JSON data, do
//
//     final dashboardlistmodel = dashboardlistmodelFromJson(jsonString);

import 'dart:convert';

LocationPopupModel locationpopupmodelFromJson(String str) =>
    LocationPopupModel.fromJson(json.decode(str));

String locationpopupmodelToJson(LocationPopupModel data) =>
    json.encode(data.toJson());

class LocationPopupModel {
  String status;
  List<popups> list;
  String code;
  String message;

  LocationPopupModel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory LocationPopupModel.fromJson(Map<String, dynamic> json) =>
      LocationPopupModel(
        status: json["status"],
        list: List<popups>.from(json["list"].map((x) => popups.fromJson(x))),
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

class popups {
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

  popups({
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

  factory popups.fromJson(Map<String, dynamic> json) => popups(
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
