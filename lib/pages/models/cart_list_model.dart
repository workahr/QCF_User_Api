// To parse this JSON data, do
//
//     final CartListmodel = CartListmodelFromJson(jsonString);

import 'dart:convert';

CartListmodel CartListmodelFromJson(String str) =>
    CartListmodel.fromJson(json.decode(str));

String CartListmodelToJson(CartListmodel data) =>
    json.encode(data.toJson());

class CartListmodel {
  String status;
  List<CartList> list;
  String code;
  String message;

  CartListmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory CartListmodel.fromJson(Map<String, dynamic> json) =>
      CartListmodel(
        status: json["status"],
        list: List<CartList>.from(
            json["list"].map((x) => CartList.fromJson(x))),
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

class CartList {
  int id;
  String? type;
  String category;
  String? dishname;
  String? rating;
  int? qty;
  String? reviewpersons;
  String? quantityPrice;
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

  CartList({
    required this.id,
    this.type,
    required this.category,
    this.dishname,
    this.rating,
    this.qty,
    this.reviewpersons,
    this.quantityPrice,
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

  factory CartList.fromJson(Map<String, dynamic> json) => CartList(
        id: json["id"],
        type: json["type"],
        category: json["category"],
        dishname: json["dishname"],
        rating: json["rating"],
        qty: json["qty"],
        reviewpersons: json["reviewpersons"],
        quantityPrice: json["quantity_price"],
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
        "qty": qty,
        "reviewpersons": reviewpersons,
        "quantity_price": quantityPrice,
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
