// To parse this JSON data, do
//
//     final OrderPreviewmodel = OrderPreviewmodelFromJson(jsonString);

import 'dart:convert';

OrderPreviewmodel OrderPreviewmodelFromJson(String str) =>
    OrderPreviewmodel.fromJson(json.decode(str));

String OrderPreviewmodelToJson(OrderPreviewmodel data) =>
    json.encode(data.toJson());

class OrderPreviewmodel {
  String status;
  List<OrderPreviewList> list;
  String code;
  String message;

  OrderPreviewmodel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory OrderPreviewmodel.fromJson(Map<String, dynamic> json) =>
      OrderPreviewmodel(
        status: json["status"],
        list: List<OrderPreviewList>.from(
            json["list"].map((x) => OrderPreviewList.fromJson(x))),
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

class OrderPreviewList {
  int id;
  String? type;
  String category;
  String? dishname;
  String? rating;
  String? qty;
  String? platformfee;
  String? gst;
  String? deliveryfee;
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

  OrderPreviewList({
    required this.id,
    this.type,
    required this.category,
    this.dishname,
    this.rating,
    this.qty,
    this.platformfee,
    this.gst,
    this.deliveryfee,
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

  factory OrderPreviewList.fromJson(Map<String, dynamic> json) =>
      OrderPreviewList(
        id: json["id"],
        type: json["type"],
        category: json["category"],
        dishname: json["dishname"],
        rating: json["rating"],
        qty: json["qty"],
        platformfee: json["platformfee"],
        gst: json["gst"],
        deliveryfee: json["deliveryfee"],
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
        "qty": qty,
        "qty": platformfee,
        "qty": gst,
        "qty": deliveryfee,
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
