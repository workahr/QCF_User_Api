// To parse this JSON data, do
//
//     final storeratinglistmodel = storeratinglistmodelFromJson(jsonString);

import 'dart:convert';

Storeratinglistmodel storeratinglistmodelFromJson(String str) =>
    Storeratinglistmodel.fromJson(json.decode(str));

String storeratinglistmodelToJson(Storeratinglistmodel data) =>
    json.encode(data.toJson());

class Storeratinglistmodel {
  String status;
  List<storerating> list;
  String code;
  String message;

  Storeratinglistmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory Storeratinglistmodel.fromJson(Map<String, dynamic> json) =>
      Storeratinglistmodel(
        status: json["status"],
        list: List<storerating>.from(
            json["list"].map((x) => storerating.fromJson(x))),
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

class storerating {
  int id;
  String? username;
  String? dishesname;
  String? description;
  String? rating;
  int star;
  String? image;
  int status;
  int active;
  int createdBy;
  dynamic createdDate;
  int updatedBy;
  dynamic updatedDate;

  storerating({
    required this.id,
    this.username,
    this.dishesname,
    this.description,
    this.rating,
    required this.star,
    this.image,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory storerating.fromJson(Map<String, dynamic> json) => storerating(
        id: json["id"],
        username: json["username"],
        dishesname: json["dishesname"],
        description: json["description"],
        rating: json["rating"],
        star: json["star"],
        image: json["image"],
        status: json["status"],
        active: json["active"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "dishesname": dishesname,
        "description": description,
        "rating": rating,
        "star": star,
        "image": image,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
