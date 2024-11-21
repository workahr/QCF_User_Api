// To parse this JSON data, do
//
//     final dashboardlistmodel = dashboardlistmodelFromJson(jsonString);

import 'dart:convert';

Dashboardlistmodel dashboardlistmodelFromJson(String str) =>
    Dashboardlistmodel.fromJson(json.decode(str));

String dashboardlistmodelToJson(Dashboardlistmodel data) =>
    json.encode(data.toJson());

class Dashboardlistmodel {
  String status;
  List<dashboardlist> list;
  String code;
  String message;

  Dashboardlistmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory Dashboardlistmodel.fromJson(Map<String, dynamic> json) =>
      Dashboardlistmodel(
        status: json["status"],
        list: List<dashboardlist>.from(
            json["list"].map((x) => dashboardlist.fromJson(x))),
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

class dashboardlist {
  int id;
  String type;
  String title;
  String image;
  String reviews;
  String offerpercentage;
  String offerupto;
  String km;
  String time;
  int status;
  int active;
  int createdBy;
  dynamic createdDate;
  int updatedBy;
  dynamic updatedDate;

  dashboardlist({
    required this.id,
    required this.type,
    required this.title,
    required this.image,
    required this.reviews,
    required this.offerpercentage,
    required this.offerupto,
    required this.km,
    required this.time,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory dashboardlist.fromJson(Map<String, dynamic> json) => dashboardlist(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        image: json["image"],
        reviews: json["reviews"],
        offerpercentage: json["offerpercentage"],
        offerupto: json["offerupto"],
        km: json["km"],
        time: json["time"],
        status: json["status"],
        active: json["active"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "image": image,
        "reviews": reviews,
        "offerpercentage": offerpercentage,
        "offerupto": offerupto,
        "km": km,
        "time": time,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
