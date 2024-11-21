// To parse this JSON data, do
//
//     final dashboardlistmodel = dashboardlistmodelFromJson(jsonString);

import 'dart:convert';

MyProfileTitleModel myprofiletitlemodelFromJson(String str) =>
    MyProfileTitleModel.fromJson(json.decode(str));

String myprofiletitlemodelToJson(MyProfileTitleModel data) =>
    json.encode(data.toJson());

class MyProfileTitleModel {
  String status;
  List<myprofiletitles> list;
  String code;
  String message;

  MyProfileTitleModel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory MyProfileTitleModel.fromJson(Map<String, dynamic> json) =>
      MyProfileTitleModel(
        status: json["status"],
        list: List<myprofiletitles>.from(
            json["list"].map((x) => myprofiletitles.fromJson(x))),
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

class myprofiletitles {
  int id;
  String icon;
  String title;

  int status;
  int active;
  int createdBy;
  dynamic createdDate;
  int updatedBy;
  dynamic updatedDate;

  myprofiletitles({
    required this.id,
    required this.icon,
    required this.title,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory myprofiletitles.fromJson(Map<String, dynamic> json) =>
      myprofiletitles(
        id: json["id"],
        icon: json["icon"],
        title: json["title"],
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
        "title": title,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
