// To parse this JSON data, do
//
//     final dashboardlistmodel = dashboardlistmodelFromJson(jsonString);

import 'dart:convert';

MyProfileModel myprofilemodelFromJson(String str) =>
    MyProfileModel.fromJson(json.decode(str));

String myprofilemodelToJson(MyProfileModel data) => json.encode(data.toJson());

class MyProfileModel {
  String status;
  List<myprofilelist> list;
  String code;
  String message;

  MyProfileModel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory MyProfileModel.fromJson(Map<String, dynamic> json) => MyProfileModel(
        status: json["status"],
        list: List<myprofilelist>.from(
            json["list"].map((x) => myprofilelist.fromJson(x))),
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

class myprofilelist {
  int id;
  String icon;
  String type;
  String address;
  String contact;

  int status;
  int active;
  int createdBy;
  dynamic createdDate;
  int updatedBy;
  dynamic updatedDate;

  myprofilelist({
    required this.id,
    required this.icon,
    required this.type,
    required this.address,
    required this.contact,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory myprofilelist.fromJson(Map<String, dynamic> json) => myprofilelist(
        id: json["id"],
        icon: json["icon"],
        type: json["type"],
        address: json["address"],
        contact: json["contact"],
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
        "contact": contact,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
