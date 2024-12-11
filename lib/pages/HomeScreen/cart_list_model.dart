// To parse this JSON data, do
//
//     final cartListModel = cartListModelFromJson(jsonString);

import 'dart:convert';

CartListModel cartListModelFromJson(String str) =>
    CartListModel.fromJson(json.decode(str));

String cartListModelToJson(CartListModel data) => json.encode(data.toJson());

class CartListModel {
  String status;
  List<CartListData> list;
  String code;
  String message;

  CartListModel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
        status: json["status"],
        list: List<CartListData>.from(
            json["list"].map((x) => CartListData.fromJson(x))),
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

class CartListData {
  int cartId;
  int storeId;
  int userId;
  int productId;
  String? sessionId;
  int quantity;
  String price;
  String quantityPrice;
  String storePrice;
  String storeTotalPrice;
  int status;
  int? createdBy;
  DateTime? createdDate;
  int? updatedBy;
  DateTime? updatedDate;
  String itemName;
  String? itemImageUrl;
  String? store_name;
  String? store_image;

  CartListData({
    required this.cartId,
    required this.storeId,
    required this.userId,
    required this.productId,
    this.sessionId,
    required this.quantity,
    required this.price,
    required this.quantityPrice,
    required this.storePrice,
    required this.storeTotalPrice,
    required this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    required this.itemName,
    this.itemImageUrl,
    this.store_name,
    this.store_image,
  });

  factory CartListData.fromJson(Map<String, dynamic> json) => CartListData(
      cartId: json["cart_id"],
      storeId: json["store_id"],
      userId: json["user_id"],
      productId: json["product_id"],
      sessionId: json["session_id"],
      quantity: json["quantity"],
      price: json["price"],
      quantityPrice: json["quantity_price"],
      storePrice: json["store_price"],
      storeTotalPrice: json["store_total_price"],
      status: json["status"],
      createdBy: json["created_by"],
      createdDate: DateTime.parse(json["created_date"]),
      updatedBy: json["updated_by"],
      updatedDate: json["updated_date"] == null
          ? null
          : DateTime.parse(json["updated_date"]),
      itemName: json["item_name"],
      itemImageUrl: json["item_image_url"],
      store_name: json["store_name"],
      store_image: json["store_image"]);

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "store_id": storeId,
        "user_id": userId,
        "product_id": productId,
        "session_id": sessionId,
        "quantity": quantity,
        "price": price,
        "quantity_price": quantityPrice,
        "store_price": storePrice,
        "store_total_price": storeTotalPrice,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate?.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate?.toIso8601String(),
        "item_name": itemName,
        "item_image_url": itemImageUrl,
        "store_name": store_name,
        "store_image": store_image,
      };
}
