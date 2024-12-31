// To parse this JSON data, do
//
//     final bannerListModel = bannerListModelFromJson(jsonString);

import 'dart:convert';

StaticBannerListModel staticbannerListModelFromJson(String str) =>
    StaticBannerListModel.fromJson(json.decode(str));

String staticbannerListModelToJson(StaticBannerListModel data) =>
    json.encode(data.toJson());

class StaticBannerListModel {
  String status;
  // List<StaticBannerListData> list;
  StaticBannerListData? list;
  String code;
  String message;

  StaticBannerListModel({
    required this.status,
    this.list,
    required this.code,
    required this.message,
  });

  factory StaticBannerListModel.fromJson(Map<String, dynamic> json) =>
      StaticBannerListModel(
        status: json["status"],
        // list: List<StaticBannerListData>.from(
        //     json["list"].map((x) => StaticBannerListData.fromJson(x))),
        list: json["list"] != null
            ? StaticBannerListData.fromJson(json["list"])
            : null,
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        // "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "list": list?.toJson(),
        "code": code,
        "message": message,
      };
}

class StaticBannerListData {
  int id;
  String? title;
  String? imageUrl;
  int status;
  int createdBy;
  DateTime createdDate;
  int? updatedBy;
  DateTime? updatedDate;

  StaticBannerListData({
    required this.id,
    this.title,
    this.imageUrl,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory StaticBannerListData.fromJson(Map<String, dynamic> json) =>
      StaticBannerListData(
        id: json["id"],
        title: json["title"],
        imageUrl: json["image_url"],
        status: json["status"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_url": imageUrl,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate?.toIso8601String(),
      };
}
