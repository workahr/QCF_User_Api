// To parse this JSON data, do
//
//     final adddressEditmodel = adddressEditmodelFromJson(jsonString);

import 'dart:convert';

AdddressEditmodel adddressEditmodelFromJson(String str) =>
    AdddressEditmodel.fromJson(json.decode(str));

String adddressEditmodelToJson(AdddressEditmodel data) =>
    json.encode(data.toJson());

class AdddressEditmodel {
  String status;
  String code;
  EditAddressList list;
  String message;

  AdddressEditmodel({
    required this.status,
    required this.code,
    required this.list,
    required this.message,
  });

  factory AdddressEditmodel.fromJson(Map<String, dynamic> json) =>
      AdddressEditmodel(
        status: json["status"],
        code: json["code"],
        list: EditAddressList.fromJson(json["list"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "list": list.toJson(),
        "message": message,
      };
}

class EditAddressList {
  int id;
  int? defaultAddress;
  String? type;
  int? userId;
  String? address;
  String? addressLine2;
  int? main_location_id;
  String? main_location;
  String? sub_location;
  int? sub_location_id;
  String? latitude;
  String? longitude;
  String? city;
  String? state;
  int? country;
  int? postcode;
  String? landmark;
  int? status;
  int? createdBy;
  DateTime createdDate;
  dynamic updatedBy;
  dynamic updatedDate;

  EditAddressList({
    required this.id,
    this.defaultAddress,
    this.type,
    this.userId,
    this.address,
    this.addressLine2,
    this.main_location_id,
    this.main_location,
    this.sub_location,
    this.sub_location_id,
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.landmark,
    this.status,
    this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory EditAddressList.fromJson(Map<String, dynamic> json) =>
      EditAddressList(
        id: json["id"],
        defaultAddress: json["default_address"],
        type: json["type"],
        userId: json["user_id"],
        address: json["address"],
        addressLine2: json["address_line_2"],
        main_location_id: json["main_location_id"],
        main_location: json["main_location"],
        sub_location: json["sub_location"],
        sub_location_id: json["sub_location_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postcode: json["postcode"],
        landmark: json["landmark"],
        status: json["status"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "default_address": defaultAddress,
        "type": type,
        "user_id": userId,
        "address": address,
        "address_line_2": addressLine2,
        "main_location_id": main_location_id,
        "main_location": main_location,
        "sub_location": sub_location,
        "sub_location_id": sub_location_id,
        "latitude": latitude,
        "longitude": longitude,
        "city": city,
        "state": state,
        "country": country,
        "postcode": postcode,
        "landmark": landmark,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}
