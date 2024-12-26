// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  String status;
  List<OrderListData> list;
  String code;
  String message;

  OrderListModel({
    required this.status,
    required this.list,
    required this.code,
    required this.message,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        status: json["status"],
        list: List<OrderListData>.from(
            json["list"].map((x) => OrderListData.fromJson(x))),
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

class OrderListData {
  int id;
  String invoiceNumber;
  String? transportId;
  int totalProduct;
  String? totalPrice;
  String? storeTotalPrice;
  int storePaidStatus;
  String? deliveryCharges;
  String? cartSessionId;
  int userId;
  int storeId;
  String? orderStatus;
  String? deliveryPartnerId;
  int prepareMin;
  String? paymentMethod;
  String? cancelReason;
  int? code;
  String? customer_code;
  int status;
  int? createdBy;
  DateTime? createdDate;
  int? updatedBy;
  DateTime? updatedDate;
  String? storeAddress;
  String? storeName;
  String? storeMobile;

  OrderListData({
    required this.id,
    required this.invoiceNumber,
    this.transportId,
    required this.totalProduct,
    this.totalPrice,
    this.storeTotalPrice,
    required this.storePaidStatus,
    this.deliveryCharges,
    this.cartSessionId,
    required this.userId,
    required this.storeId,
    this.orderStatus,
    this.deliveryPartnerId,
    required this.prepareMin,
    this.paymentMethod,
    this.cancelReason,
    this.code,
    this.customer_code,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    this.storeAddress,
    this.storeName,
    this.storeMobile,
  });

  factory OrderListData.fromJson(Map<String, dynamic> json) => OrderListData(
        id: json["id"],
        invoiceNumber: json["invoice_number"],
        transportId: json["transport_id"],
        totalProduct: json["total_product"],
        totalPrice: json["total_price"],
        storeTotalPrice: json["store_total_price"],
        storePaidStatus: json["store_paid_status"],
        deliveryCharges: json["delivery_charges"],
        cartSessionId: json["cart_session_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        orderStatus: json["order_status"],
        deliveryPartnerId: json["delivery_partner_id"],
        prepareMin: json["prepare_min"],
        paymentMethod: json["payment_method"],
        cancelReason: json["cancel_reason"],
        code: json["code"],
        customer_code: json["customer_code"],
        status: json["status"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
        storeAddress: json["store_address"],
        storeName: json["store_name"],
        storeMobile: json["store_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "transport_id": transportId,
        "total_product": totalProduct,
        "total_price": totalPrice,
        "store_total_price": storeTotalPrice,
        "store_paid_status": storePaidStatus,
        "delivery_charges": deliveryCharges,
        "cart_session_id": cartSessionId,
        "user_id": userId,
        "store_id": storeId,
        "order_status": orderStatus,
        "delivery_partner_id": deliveryPartnerId,
        "prepare_min": prepareMin,
        "payment_method": paymentMethod,
        "cancel_reason": cancelReason,
        "code": code,
        "customer_code": customer_code,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate?.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate?.toIso8601String(),
        "store_address": storeAddress,
        "store_name": storeName,
        "store_mobile": storeMobile,
      };
}
