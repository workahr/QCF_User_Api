// // To parse this JSON data, do
// //
// //     final cancelOrderPreviewmodel = cancelOrderPreviewmodelFromJson(jsonString);

// import 'dart:convert';

// CancelOrderPreviewmodel cancelOrderPreviewmodelFromJson(String str) =>
//     CancelOrderPreviewmodel.fromJson(json.decode(str));

// String cancelOrderPreviewmodelToJson(CancelOrderPreviewmodel data) =>
//     json.encode(data.toJson());

// class CancelOrderPreviewmodel {
//   String status;
//   ListClass list;
//   String code;
//   List<Item> items;
//   List<Address> address;
//   StoreAddress storeAddress;
//   Customer customer;
//   List<dynamic> deliveryboy;
//   String message;

//   CancelOrderPreviewmodel({
//     required this.status,
//     required this.list,
//     required this.code,
//     required this.items,
//     required this.address,
//     required this.storeAddress,
//     required this.customer,
//     required this.deliveryboy,
//     required this.message,
//   });

//   factory CancelOrderPreviewmodel.fromJson(Map<String, dynamic> json) =>
//       CancelOrderPreviewmodel(
//         status: json["status"],
//         list: ListClass.fromJson(json["list"]),
//         code: json["code"],
//         items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
//         address:
//             List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
//         storeAddress: StoreAddress.fromJson(json["store_address"]),
//         customer: Customer.fromJson(json["customer"]),
//         deliveryboy: List<dynamic>.from(json["deliveryboy"].map((x) => x)),
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "list": list.toJson(),
//         "code": code,
//         "items": List<dynamic>.from(items.map((x) => x.toJson())),
//         "address": List<dynamic>.from(address.map((x) => x.toJson())),
//         "store_address": storeAddress.toJson(),
//         "customer": customer.toJson(),
//         "deliveryboy": List<dynamic>.from(deliveryboy.map((x) => x)),
//         "message": message,
//       };
// }

// class Address {
//   int? id;
//   int? orderId;
//   String? address;
//   String? landmark;
//   String? city;
//   String? state;
//   String? country;
//   String? pincode;
//   String? addressLine2;
//   int? status;
//   DateTime? createdDate;

//   Address({
//     this.id,
//     this.orderId,
//     this.address,
//     this.landmark,
//     this.city,
//     this.state,
//     this.country,
//     this.pincode,
//     this.addressLine2,
//     this.status,
//     this.createdDate,
//   });

//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//         id: json["id"],
//         orderId: json["order_id"],
//         address: json["address"],
//         landmark: json["landmark"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         pincode: json["pincode"],
//         addressLine2: json["address_line_2"],
//         status: json["status"],
//         createdDate: DateTime.parse(json["created_date"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "order_id": orderId,
//         "address": address,
//         "landmark": landmark,
//         "city": city,
//         "state": state,
//         "country": country,
//         "pincode": pincode,
//         "address_line_2": addressLine2,
//         "status": status,
//         "created_date": createdDate!.toIso8601String(),
//       };
// }

// class Customer {
//   int? id;
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
//   DateTime? createdDate;
//   int? updatedBy;
//   DateTime? updatedDate;
//   dynamic mobilePushId;
//   String? imageUrl;
//   dynamic licenseNo;
//   dynamic vehicleNo;
//   dynamic vehicleName;
//   dynamic licenseFrontImg;
//   dynamic licenseBackImg;
//   dynamic vehicleImg;
//   dynamic address;
//   dynamic area;
//   dynamic city;
//   dynamic pincode;

//   Customer({
//     this.id,
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
//     this.createdDate,
//     this.updatedBy,
//     this.updatedDate,
//     required this.mobilePushId,
//     this.imageUrl,
//     required this.licenseNo,
//     required this.vehicleNo,
//     required this.vehicleName,
//     required this.licenseFrontImg,
//     required this.licenseBackImg,
//     required this.vehicleImg,
//     required this.address,
//     required this.area,
//     required this.city,
//     required this.pincode,
//   });

//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
//         updatedDate: DateTime.parse(json["updated_date"]),
//         mobilePushId: json["mobile_push_id"],
//         imageUrl: json["image_url"],
//         licenseNo: json["license_no"],
//         vehicleNo: json["vehicle_no"],
//         vehicleName: json["vehicle_name"],
//         licenseFrontImg: json["license_front_img"],
//         licenseBackImg: json["license_back_img"],
//         vehicleImg: json["vehicle_img"],
//         address: json["address"],
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
//         "created_date": createdDate!.toIso8601String(),
//         "updated_by": updatedBy,
//         "updated_date": updatedDate!.toIso8601String(),
//         "mobile_push_id": mobilePushId,
//         "image_url": imageUrl,
//         "license_no": licenseNo,
//         "vehicle_no": vehicleNo,
//         "vehicle_name": vehicleName,
//         "license_front_img": licenseFrontImg,
//         "license_back_img": licenseBackImg,
//         "vehicle_img": vehicleImg,
//         "address": address,
//         "area": area,
//         "city": city,
//         "pincode": pincode,
//       };
// }

// class Item {
//   int orderItemId;
//   int? storeId;
//   int? orderId;
//   int? productId;
//   String? productName;
//   int? userId;
//   String? price;
//   int? quantity;
//   String? totalPrice;
//   String? storePrice;
//   String? storeTotalPrice;
//   String? imageUrl;
//   int? status;
//   int? createdBy;
//   DateTime? createdDate;
//   dynamic updatedBy;
//   dynamic updatedDate;

//   Item({
//     required this.orderItemId,
//     this.storeId,
//     this.orderId,
//     this.productId,
//     this.productName,
//     this.userId,
//     this.price,
//     this.quantity,
//     this.totalPrice,
//     this.storePrice,
//     this.storeTotalPrice,
//     this.imageUrl,
//     this.status,
//     this.createdBy,
//     this.createdDate,
//     required this.updatedBy,
//     required this.updatedDate,
//   });

//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//         orderItemId: json["order_item_id"],
//         storeId: json["store_id"],
//         orderId: json["order_id"],
//         productId: json["product_id"],
//         productName: json["product_name"],
//         userId: json["user_id"],
//         price: json["price"],
//         quantity: json["quantity"],
//         totalPrice: json["total_price"],
//         storePrice: json["store_price"],
//         storeTotalPrice: json["store_total_price"],
//         imageUrl: json["image_url"],
//         status: json["status"],
//         createdBy: json["created_by"],
//         createdDate: DateTime.parse(json["created_date"]),
//         updatedBy: json["updated_by"],
//         updatedDate: json["updated_date"],
//       );

//   Map<String, dynamic> toJson() => {
//         "order_item_id": orderItemId,
//         "store_id": storeId,
//         "order_id": orderId,
//         "product_id": productId,
//         "product_name": productName,
//         "user_id": userId,
//         "price": price,
//         "quantity": quantity,
//         "total_price": totalPrice,
//         "store_price": storePrice,
//         "store_total_price": storeTotalPrice,
//         "image_url": imageUrl,
//         "status": status,
//         "created_by": createdBy,
//         "created_date": createdDate!.toIso8601String(),
//         "updated_by": updatedBy,
//         "updated_date": updatedDate,
//       };
// }

// class ListClass {
//   int id;
//   String? invoiceNumber;
//   dynamic transportId;
//   int? totalProduct;
//   String? totalPrice;
//   String? storeTotalPrice;
//   int? storePaidStatus;
//   String? deliveryCharges;
//   int? cartSessionId;
//   int? userId;
//   int? storeId;
//   String? orderStatus;
//   String? deliveryPartnerId;
//   int? prepareMin;
//   String? paymentMethod;
//   dynamic cancelReason;
//   int? code;
//   int? status;
//   int? createdBy;
//   DateTime? createdDate;
//   int? updatedBy;
//   DateTime updatedDate;
//   String? storeAddress;
//   String? storeName;
//   String? storeMobile;

//   ListClass({
//     required this.id,
//     this.invoiceNumber,
//     required this.transportId,
//     this.totalProduct,
//     this.totalPrice,
//     this.storeTotalPrice,
//     this.storePaidStatus,
//     this.deliveryCharges,
//     this.cartSessionId,
//     this.userId,
//     this.storeId,
//     this.orderStatus,
//     this.deliveryPartnerId,
//     this.prepareMin,
//     this.paymentMethod,
//     required this.cancelReason,
//     this.code,
//     this.status,
//     this.createdBy,
//     required this.createdDate,
//     this.updatedBy,
//     required this.updatedDate,
//     this.storeAddress,
//     this.storeName,
//     this.storeMobile,
//   });

//   factory ListClass.fromJson(Map<String, dynamic> json) => ListClass(
//         id: json["id"],
//         invoiceNumber: json["invoice_number"],
//         transportId: json["transport_id"],
//         totalProduct: json["total_product"],
//         totalPrice: json["total_price"],
//         storeTotalPrice: json["store_total_price"],
//         storePaidStatus: json["store_paid_status"],
//         deliveryCharges: json["delivery_charges"],
//         cartSessionId: json["cart_session_id"],
//         userId: json["user_id"],
//         storeId: json["store_id"],
//         orderStatus: json["order_status"],
//         deliveryPartnerId: json["delivery_partner_id"],
//         prepareMin: json["prepare_min"],
//         paymentMethod: json["payment_method"],
//         cancelReason: json["cancel_reason"],
//         code: json["code"],
//         status: json["status"],
//         createdBy: json["created_by"],
//         createdDate: DateTime.parse(json["created_date"]),
//         updatedBy: json["updated_by"],
//         updatedDate: DateTime.parse(json["updated_date"]),
//         storeAddress: json["store_address"],
//         storeName: json["store_name"],
//         storeMobile: json["store_mobile"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "invoice_number": invoiceNumber,
//         "transport_id": transportId,
//         "total_product": totalProduct,
//         "total_price": totalPrice,
//         "store_total_price": storeTotalPrice,
//         "store_paid_status": storePaidStatus,
//         "delivery_charges": deliveryCharges,
//         "cart_session_id": cartSessionId,
//         "user_id": userId,
//         "store_id": storeId,
//         "order_status": orderStatus,
//         "delivery_partner_id": deliveryPartnerId,
//         "prepare_min": prepareMin,
//         "payment_method": paymentMethod,
//         "cancel_reason": cancelReason,
//         "code": code,
//         "status": status,
//         "created_by": createdBy,
//         "created_date": createdDate!.toIso8601String(),
//         "updated_by": updatedBy,
//         "updated_date": updatedDate.toIso8601String(),
//         "store_address": storeAddress,
//         "store_name": storeName,
//         "store_mobile": storeMobile,
//       };
// }

// class StoreAddress {
//   int storeId;
//   int userId;
//   String? name;
//   String? mobile;
//   String? email;
//   String? address;
//   String? city;
//   String? state;
//   dynamic country;
//   dynamic logo;
//   dynamic gstNo;
//   dynamic panNo;
//   dynamic terms;
//   String? zipcode;
//   dynamic frontImg;
//   String? onlineVisibility;
//   dynamic tags;
//   int? status;
//   dynamic createdBy;
//   dynamic createdDate;
//   dynamic updatedBy;
//   dynamic updatedDate;
//   dynamic slug;
//   int? storeStatus;

//   StoreAddress({
//     required this.storeId,
//     required this.userId,
//     this.name,
//     this.mobile,
//     this.email,
//     this.address,
//     this.city,
//     this.state,
//     required this.country,
//     required this.logo,
//     required this.gstNo,
//     required this.panNo,
//     required this.terms,
//     this.zipcode,
//     required this.frontImg,
//     this.onlineVisibility,
//     required this.tags,
//     this.status,
//     required this.createdBy,
//     required this.createdDate,
//     required this.updatedBy,
//     required this.updatedDate,
//     required this.slug,
//     this.storeStatus,
//   });

//   factory StoreAddress.fromJson(Map<String, dynamic> json) => StoreAddress(
//         storeId: json["store_id"],
//         userId: json["user_id"],
//         name: json["name"],
//         mobile: json["mobile"],
//         email: json["email"],
//         address: json["address"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         logo: json["logo"],
//         gstNo: json["gst_no"],
//         panNo: json["pan_no"],
//         terms: json["terms"],
//         zipcode: json["zipcode"],
//         frontImg: json["front_img"],
//         onlineVisibility: json["online_visibility"],
//         tags: json["tags"],
//         status: json["status"],
//         createdBy: json["created_by"],
//         createdDate: json["created_date"],
//         updatedBy: json["updated_by"],
//         updatedDate: json["updated_date"],
//         slug: json["slug"],
//         storeStatus: json["store_status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "store_id": storeId,
//         "user_id": userId,
//         "name": name,
//         "mobile": mobile,
//         "email": email,
//         "address": address,
//         "city": city,
//         "state": state,
//         "country": country,
//         "logo": logo,
//         "gst_no": gstNo,
//         "pan_no": panNo,
//         "terms": terms,
//         "zipcode": zipcode,
//         "front_img": frontImg,
//         "online_visibility": onlineVisibility,
//         "tags": tags,
//         "status": status,
//         "created_by": createdBy,
//         "created_date": createdDate,
//         "updated_by": updatedBy,
//         "updated_date": updatedDate,
//         "slug": slug,
//         "store_status": storeStatus,
//       };
// }
