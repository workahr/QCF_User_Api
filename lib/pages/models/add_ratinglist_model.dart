// To parse this JSON data, do
//
//     final AddRatinglistmodel = AddRatinglistmodelFromJson(jsonString);

import 'dart:convert';

AddRatinglistmodel AddRatinglistmodelFromJson(String str) =>
    AddRatinglistmodel.fromJson(json.decode(str));

String AddRatinglistmodelToJson(AddRatinglistmodel data) =>
    json.encode(data.toJson());

class AddRatinglistmodel {
  String status;
  List<AddRatingList> list;
  String code;
  String message;

  AddRatinglistmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory AddRatinglistmodel.fromJson(Map<String, dynamic> json) =>
      AddRatinglistmodel(
        status: json["status"],
        list: List<AddRatingList>.from(
            json["list"].map((x) => AddRatingList.fromJson(x))),
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

class AddRatingList {
  int id;
  String? storeName;
  int? storeRating;
  int? personRating;
  String? qty;
  String? deliveryperson;
  String? dishimage;
  List<Dishes> dishes;
  int status;
  int active;
  int createdBy;
  String? createdDate;
  int updatedBy;
  String? updatedDate;

  AddRatingList({
    required this.id,
    required this.storeName,
    this.storeRating,
    this.personRating,
    this.qty,
    this.deliveryperson,
    this.dishimage,
    required this.dishes,
    required this.status,
    required this.active,
    required this.createdBy,
    this.createdDate,
    required this.updatedBy,
    this.updatedDate,
  });

  factory AddRatingList.fromJson(Map<String, dynamic> json) => AddRatingList(
        id: json["id"],
        storeName: json["store_name"],
        storeRating: json["store_rating"],
        personRating: json["person_rating"],
        qty: json["qty"],
        deliveryperson: json["delivery_person"],
        dishimage: json["dishimage"],
        dishes:
            List<Dishes>.from(json["dishes"].map((x) => Dishes.fromJson(x))),
        status: json["status"],
        active: json["active"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
        "store_rating": storeRating,
        "person_rating": personRating,
        "qty": qty,
        "delivery_person": deliveryperson,
        "dishimage": dishimage,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}

class Dishes {
  String? name;
  int? rating;

  Dishes({
    required this.name,
    required this.rating,
  });

  factory Dishes.fromJson(Map<String, dynamic> json) => Dishes(
        name: json["name"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "rating": rating,
      };
}
