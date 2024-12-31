// To parse this JSON data, do
//
//     final addressListmodel = addressListmodelFromJson(jsonString);

import 'dart:convert';

AddressListmodel addressListmodelFromJson(String str) =>
    AddressListmodel.fromJson(json.decode(str));

String addressListmodelToJson(AddressListmodel data) =>
    json.encode(data.toJson());

class AddressListmodel {
  String status;
  String code;
  List<AddressList> list;
  String message;

  AddressListmodel({
    required this.status,
    required this.code,
    required this.list,
    required this.message,
  });

  factory AddressListmodel.fromJson(Map<String, dynamic> json) =>
      AddressListmodel(
        status: json["status"],
        code: json["code"],
        list: List<AddressList>.from(
            json["list"].map((x) => AddressList.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "message": message,
      };
}

class AddressList {
  int id;
  int? defaultAddress;
  String? type;
  int? userId;
  String? address;
  String? addressLine2;
  int? main_location_id;
  int? sub_location_id;
  String? latitude;
  String? longitude;
  String? price;
  String? city;
  String? state;
  int? country;
  int? postcode;
  String? landmark;
  int? status;
  int? createdBy;
  DateTime? createdDate;
  int? updatedBy;
  DateTime? updatedDate;

  AddressList({
    required this.id,
    this.defaultAddress,
    this.type,
    this.userId,
    this.address,
    this.addressLine2,
    this.main_location_id,
    this.sub_location_id,
    this.latitude,
    this.longitude,
    this.price,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.landmark,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        id: json["id"],
        defaultAddress: json["default_address"],
        type: json["type"],
        userId: json["user_id"],
        address: json["address"] == null ? '' : json["address"],
        addressLine2:
            json["address_line_2"] == null ? '' : json["address_line_2"],
        main_location_id: json["main_location_id"],
        sub_location_id: json["sub_location_id"],
        latitude: json["latitude"] == null ? '' : json["latitude"],
        longitude: json["longitude"] == null ? '' : json["longitude"],
        city: json["city"] == null ? '' : json["city"],
        state: json["state"] == null ? '' : json["state"],
        country: json["country"] == null ? '' : json["country"],
        postcode: json["postcode"] == null ? '' : json["postcode"],
        landmark: json["landmark"] == null ? '' : json["landmark"],
        price: json["price"] == null ? '' : json["price"],
        status: json["status"],
        createdBy: json["created_by"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "default_address": defaultAddress,
        "type": type,
        "user_id": userId,
        "address": address,
        "address_line_2": addressLine2,
        "main_location_id": main_location_id,
        "sub_location_id": sub_location_id,
        "latitude": latitude,
        "longitude": longitude,
        "city": city,
        "state": state,
        "country": country,
        "postcode": postcode,
        "landmark": landmark,
        "price": price,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate!.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate!.toIso8601String(),
      };
}
