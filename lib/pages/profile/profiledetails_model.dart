import 'dart:convert';

// Top-level functions for encoding and decoding
UserDetailsModel userDetailsmodelFromJson(String str) =>
    UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) =>
    json.encode(data.toJson());

// Main UserDetailsModel class
class UserDetailsModel {
  String? status;
  ProfileDetails? list;
  String? code;
  String? message;

  UserDetailsModel({
    this.status,
    this.list,
    this.code,
    this.message,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        status: json["status"] ?? "unknown",
        list:
            json["list"] != null ? ProfileDetails.fromJson(json["list"]) : null,
        code: json["code"] ?? "error",
        message: json["message"] ?? "No message provided",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "list": list?.toJson(),
        "code": code,
        "message": message,
      };
}

// ProfileDetails class
class ProfileDetails {
  int id;
  String? username;
  String? password;
  String? fullname;
  String? email;
  String? mobile;
  int? role;
  String? regOtp;
  int? status;
  int? active;
  int? createdBy;
  DateTime? createdDate;
  int? updatedBy;
  DateTime? updatedDate;
  String? mobilePushId;
  String? imageUrl;
  String? licenseNo;
  String? vehicleNo;
  String? vehicleName;
  String? licenseFrontImg;
  String? licenseBackImg;
  String? vehicleImg;
  List<Address> address;
  String? area;
  String? city;
  String? pincode;

  ProfileDetails({
    required this.id,
    this.username,
    this.password,
    this.fullname,
    this.email,
    this.mobile,
    this.role,
    this.regOtp,
    this.status,
    this.active,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.mobilePushId,
    this.imageUrl,
    this.licenseNo,
    this.vehicleNo,
    this.vehicleName,
    this.licenseFrontImg,
    this.licenseBackImg,
    this.vehicleImg,
    this.address = const [],
    this.area,
    this.city,
    this.pincode,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) => ProfileDetails(
        id: json["id"] ?? 0,
        username: json["username"],
        password: json["password"],
        fullname: json["fullname"],
        email: json["email"],
        mobile: json["mobile"],
        role: json["role"],
        regOtp: json["reg_otp"],
        status: json["status"],
        active: json["active"],
        createdBy: json["created_by"],
        createdDate: json["created_date"] != null
            ? DateTime.parse(json["created_date"])
            : null,
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] != null
            ? DateTime.parse(json["updated_date"])
            : null,
        mobilePushId: json["mobile_push_id"],
        imageUrl: json["image_url"],
        licenseNo: json["license_no"],
        vehicleNo: json["vehicle_no"],
        vehicleName: json["vehicle_name"],
        licenseFrontImg: json["license_front_img"],
        licenseBackImg: json["license_back_img"],
        vehicleImg: json["vehicle_img"],
        address: json["address"] != null
            ? List<Address>.from(
                json["address"].map((x) => Address.fromJson(x)))
            : [],
        area: json["area"],
        city: json["city"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "fullname": fullname,
        "email": email,
        "mobile": mobile,
        "role": role,
        "reg_otp": regOtp,
        "status": status,
        "active": active,
        "created_by": createdBy,
        "created_date": createdDate?.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate?.toIso8601String(),
        "mobile_push_id": mobilePushId,
        "image_url": imageUrl,
        "license_no": licenseNo,
        "vehicle_no": vehicleNo,
        "vehicle_name": vehicleName,
        "license_front_img": licenseFrontImg,
        "license_back_img": licenseBackImg,
        "vehicle_img": vehicleImg,
        "address": List<dynamic>.from(address.map((x) => x.toJson())),
        "area": area,
        "city": city,
        "pincode": pincode,
      };
}

// Address class
class Address {
  int id;
  int? defaultAddress;
  String? type;
  int? userId;
  String? address;
  String? addressLine2;
  String? city;
  String? state;
  int? country;
  int? postcode;
  String? landmark;
  int status;
  int? createdBy;
  DateTime? createdDate;
  int? updatedBy;
  DateTime? updatedDate;

  Address({
    required this.id,
    this.defaultAddress,
    this.type,
    this.userId,
    this.address,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.landmark,
    required this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] ?? 0,
        defaultAddress: json["default_address"],
        type: json["type"],
        userId: json["user_id"],
        address: json["address"],
        addressLine2: json["address_line_2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postcode: json["postcode"],
        landmark: json["landmark"],
        status: json["status"] ?? 0,
        createdBy: json["created_by"],
        createdDate: json["created_date"] != null
            ? DateTime.parse(json["created_date"])
            : null,
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] != null
            ? DateTime.parse(json["updated_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "default_address": defaultAddress,
        "type": type,
        "user_id": userId,
        "address": address,
        "address_line_2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "postcode": postcode,
        "landmark": landmark,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate?.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate?.toIso8601String(),
      };
}






// // To parse this JSON data, do
// //
// //     final userDetailsmodel = userDetailsmodelFromJson(jsonString);

// import 'dart:convert';

// UserDetailsmodel userDetailsmodelFromJson(String str) =>
//     UserDetailsmodel.fromJson(json.decode(str));

// String userDetailsmodelToJson(UserDetailsmodel data) =>
//     json.encode(data.toJson());

// class UserDetailsmodel {
//   String status;
//   ProfileDetails list;
//   String code;
//   String message;

//   UserDetailsmodel({
//     required this.status,
//     required this.list,
//     required this.code,
//     required this.message,
//   });

//   factory UserDetailsmodel.fromJson(Map<String, dynamic> json) =>
//       UserDetailsmodel(
//         status: json["status"],
//         list: ProfileDetails.fromJson(json["list"]),
//         code: json["code"],
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "list": list.toJson(),
//         "code": code,
//         "message": message,
//       };
// }

// class ProfileDetails {
//   int id;
//   String? username;
//   String? password;
//   String? fullname;
//   String? email;
//   String? mobile;
//   int? role;
//   String? regOtp;
//   int? status;
//   int? active;
//   int? createdBy;
//   DateTime createdDate;
//   int? updatedBy;
//   String? updatedDate;
//   String? mobilePushId;
//   String? imageUrl;
//   String? licenseNo;
//   String? vehicleNo;
//   String? vehicleName;
//   String? licenseFrontImg;
//   String? licenseBackImg;
//   String? vehicleImg;
//   List<Address> address;
//   String? area;
//   String? city;
//   String? pincode;

//   ProfileDetails({
//     required this.id,
//     this.username,
//     this.password,
//     this.fullname,
//     this.email,
//     this.mobile,
//     this.role,
//     this.regOtp,
//     this.status,
//     this.active,
//     this.createdBy,
//     required this.createdDate,
//     required this.updatedBy,
//     this.updatedDate,
//     this.mobilePushId,
//     this.imageUrl,
//     this.licenseNo,
//     this.vehicleNo,
//     this.vehicleName,
//     this.licenseFrontImg,
//     this.licenseBackImg,
//     this.vehicleImg,
//     required this.address,
//     this.area,
//     this.city,
//     this.pincode,
//   });

//   factory ProfileDetails.fromJson(Map<String, dynamic> json) => ProfileDetails(
//         id: json["id"],
//         username: json["username"],
//         password: json["password"],
//         fullname: json["fullname"],
//         email: json["email"],
//         mobile: json["mobile"],
//         role: json["role"],
//         regOtp: json["reg_otp"],
//         status: json["status"],
//         active: json["active"],
//         createdBy: json["created_by"],
//         createdDate: DateTime.parse(json["created_date"]),
//         updatedBy: json["updated_by"],
//         updatedDate: json["updated_date"],
//         mobilePushId: json["mobile_push_id"],
//         imageUrl: json["image_url"],
//         licenseNo: json["license_no"],
//         vehicleNo: json["vehicle_no"],
//         vehicleName: json["vehicle_name"],
//         licenseFrontImg: json["license_front_img"],
//         licenseBackImg: json["license_back_img"],
//         vehicleImg: json["vehicle_img"],
//         address:
//             List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
//         area: json["area"],
//         city: json["city"],
//         pincode: json["pincode"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "username": username,
//         "password": password,
//         "fullname": fullname,
//         "email": email,
//         "mobile": mobile,
//         "role": role,
//         "reg_otp": regOtp,
//         "status": status,
//         "active": active,
//         "created_by": createdBy,
//         "created_date": createdDate.toIso8601String(),
//         "updated_by": updatedBy,
//         "updated_date": updatedDate,
//         "mobile_push_id": mobilePushId,
//         "image_url": imageUrl,
//         "license_no": licenseNo,
//         "vehicle_no": vehicleNo,
//         "vehicle_name": vehicleName,
//         "license_front_img": licenseFrontImg,
//         "license_back_img": licenseBackImg,
//         "vehicle_img": vehicleImg,
//         "address": List<dynamic>.from(address.map((x) => x.toJson())),
//         "area": area,
//         "city": city,
//         "pincode": pincode,
//       };
// }

// class Address {
//   int id;
//   int? defaultAddress;
//   String? type;
//   int? userId;
//   String? address;
//   String? addressLine2;
//   String? city;
//   String? state;
//   int? country;
//   int? postcode;
//   String? landmark;
//   int status;
//   int? createdBy;
//   DateTime createdDate;
//   int? updatedBy;
//   DateTime? updatedDate;

//   Address({
//     required this.id,
//     this.defaultAddress,
//     this.type,
//     this.userId,
//     this.address,
//     this.addressLine2,
//     this.city,
//     this.state,
//     this.country,
//     this.postcode,
//     this.landmark,
//     required this.status,
//     this.createdBy,
//     required this.createdDate,
//     this.updatedBy,
//     this.updatedDate,
//   });

//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//         id: json["id"],
//         defaultAddress: json["default_address"],
//         type: json["type"],
//         userId: json["user_id"],
//         address: json["address"],
//         addressLine2: json["address_line_2"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         postcode: json["postcode"],
//         landmark: json["landmark"],
//         status: json["status"],
//         createdBy: json["created_by"],
//         createdDate: DateTime.parse(json["created_date"]),
//         updatedBy: json["updated_by"],
//         updatedDate: DateTime.parse(json["updated_date"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "default_address": defaultAddress,
//         "type": type,
//         "user_id": userId,
//         "address": address,
//         "address_line_2": addressLine2,
//         "city": city,
//         "state": state,
//         "country": country,
//         "postcode": postcode,
//         "landmark": landmark,
//         "status": status,
//         "created_by": createdBy,
//         "created_date": createdDate.toIso8601String(),
//         "updated_by": updatedBy,
//         "updated_date": updatedDate?.toIso8601String(),
//       };
// }
