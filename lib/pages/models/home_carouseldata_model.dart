// To parse this JSON data, do
//
//     final driverListData = driverListDataFromJson(jsonString);

import 'dart:convert';

HomeCarouselData homecarouselDataFromJson(String str) =>
    HomeCarouselData.fromJson(json.decode(str));

String homecarouselDataToJson(HomeCarouselData data) =>
    json.encode(data.toJson());

class HomeCarouselData {
  String status;
  List<carousels> list;
  String code;
  String message;

  HomeCarouselData({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory HomeCarouselData.fromJson(Map<String, dynamic> json) =>
      HomeCarouselData(
        status: json["status"],
        list: List<carousels>.from(
            json["list"].map((x) => carousels.fromJson(x))),
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

class carousels {
  int id;

  String image;

  int status;
  int active;
  int createdBy;
  DateTime createdDate;
  int? updatedBy;
  DateTime? updatedDate;

  carousels({
    required this.id,
    required this.image,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory carousels.fromJson(Map<String, dynamic> json) => carousels(
        id: json["id"],
        image: json["image"],
        status: json["status"],
        active: json["active"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate?.toIso8601String(),
      };
}
