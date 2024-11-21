// To parse this JSON data, do
//
//     final storedishlistmodel = storedishlistmodelFromJson(jsonString);

import 'dart:convert';

Storedishlistmodel storedishlistmodelFromJson(String str) =>
    Storedishlistmodel.fromJson(json.decode(str));

String storedishlistmodelToJson(Storedishlistmodel data) =>
    json.encode(data.toJson());

class Storedishlistmodel {
  String status;
  List<StoreDish> list;
  String code;
  String message;

  Storedishlistmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory Storedishlistmodel.fromJson(Map<String, dynamic> json) =>
      Storedishlistmodel(
        status: json["status"],
        list: List<StoreDish>.from(
            json["list"].map((x) => StoreDish.fromJson(x))),
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

class StoreDish {
  int id;
  String? type;
  String category;
  String? dishname;
  String? rating;
  String? reviewpersons;
  String? actualprice;
  String? discountprice;
  String? description;
  String? dishimage;
  int status;
  int active;
  int createdBy;
  String? createdDate;
  int updatedBy;
  String? updatedDate;

  StoreDish({
    required this.id,
    this.type,
    required this.category,
    this.dishname,
    this.rating,
    this.reviewpersons,
    this.actualprice,
    this.discountprice,
    this.description,
    this.dishimage,
    required this.status,
    required this.active,
    required this.createdBy,
    this.createdDate,
    required this.updatedBy,
    this.updatedDate,
  });

  factory StoreDish.fromJson(Map<String, dynamic> json) => StoreDish(
        id: json["id"],
        type: json["type"],
        category: json["category"],
        dishname: json["dishname"],
        rating: json["rating"],
        reviewpersons: json["reviewpersons"],
        actualprice: json["actualprice"],
        discountprice: json["discountprice"],
        description: json["description"],
        dishimage: json["dishimage"],
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
        "category": category,
        "dishname": dishname,
        "rating": rating,
        "reviewpersons": reviewpersons,
        "actualprice": actualprice,
        "discountprice": discountprice,
        "description": description,
        "dishimage": dishimage,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
