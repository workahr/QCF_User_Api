// To parse this JSON data, do
//
//     final bannerListModel = bannerListModelFromJson(jsonString);

import 'dart:convert';

BannerListModel bannerListModelFromJson(String str) =>
    BannerListModel.fromJson(json.decode(str));

String bannerListModelToJson(BannerListModel data) =>
    json.encode(data.toJson());

class BannerListModel {
  String status;
  List<BannerListData> list;
  String code;
  String message;

  BannerListModel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory BannerListModel.fromJson(Map<String, dynamic> json) =>
      BannerListModel(
        status: json["status"],
        list: List<BannerListData>.from(
            json["list"].map((x) => BannerListData.fromJson(x))),
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

class BannerListData {
  int id;
  String? title;
  String? imageUrl;
  int status;
  int createdBy;
  DateTime createdDate;
  int? updatedBy;
  DateTime? updatedDate;

  BannerListData({
    required this.id,
    this.title,
    this.imageUrl,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory BannerListData.fromJson(Map<String, dynamic> json) => BannerListData(
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
