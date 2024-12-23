// To parse this JSON data, do
//
//     final storedetailmenulistmodel = storedetailmenulistmodelFromJson(jsonString);

import 'dart:convert';

Storedetailmenulistmodel storedetailmenulistmodelFromJson(String str) =>
    Storedetailmenulistmodel.fromJson(json.decode(str));

String storedetailmenulistmodelToJson(Storedetailmenulistmodel data) =>
    json.encode(data.toJson());

class Storedetailmenulistmodel {
  String status;
  StoreDetails details;
  String code;
  List<Product> productList;
  List<CategoryProductList> categoryProductList;
  String message;

  Storedetailmenulistmodel({
    required this.status,
    required this.details,
    required this.code,
    required this.productList,
    required this.categoryProductList,
    required this.message,
  });

  factory Storedetailmenulistmodel.fromJson(Map<String, dynamic> json) =>
      Storedetailmenulistmodel(
        status: json["status"],
        details: StoreDetails.fromJson(json["details"]),
        code: json["code"],
        productList: List<Product>.from(
            json["product_list"].map((x) => Product.fromJson(x))),
        categoryProductList: List<CategoryProductList>.from(
            json["category_product_list"]
                .map((x) => CategoryProductList.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "details": details.toJson(),
        "code": code,
        "product_list": List<dynamic>.from(productList.map((x) => x.toJson())),
        "category_product_list":
            List<dynamic>.from(categoryProductList.map((x) => x.toJson())),
        "message": message,
      };
}

class CategoryProductList {
  int categoryId;
  String? categoryName;
  String? description;
  String? slug;
  int? serial;
  String? imageUrl;
  List<Product> products;
  dynamic createdDate;

  CategoryProductList({
    required this.categoryId,
    this.categoryName,
    this.description,
    this.slug,
    this.serial,
    this.imageUrl,
    required this.products,
    required this.createdDate,
  });

  factory CategoryProductList.fromJson(Map<String, dynamic> json) =>
      CategoryProductList(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        description: json["description"],
        slug: json["slug"],
        serial: json["serial"],
        imageUrl: json["image_url"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        createdDate: json["created_date"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "description": description,
        "slug": slug,
        "serial": serial,
        "image_url": imageUrl,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "created_date": createdDate,
      };
}

class Product {
  int itemId;
  int storeId;
  String? itemName;
  int? itemType;
  String? itemDesc;
  String? itemPrice;
  String? storePrice;
  String? itemOfferPrice;
  int? itemPriceType;
  int? itemCategoryId;
  int? taxId;
  String? itemImageUrl;
  int? itemStock;
  String? itemTags;
  int status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;

  Product({
    required this.itemId,
    required this.storeId,
    this.itemName,
    this.itemType,
    this.itemDesc,
    this.itemPrice,
    this.storePrice,
    this.itemOfferPrice,
    this.itemPriceType,
    this.itemCategoryId,
    this.taxId,
    this.itemImageUrl,
    this.itemStock,
    this.itemTags,
    required this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        itemId: json["item_id"],
        storeId: json["store_id"],
        itemName: json["item_name"],
        itemType: json["item_type"],
        itemDesc: json["item_desc"],
        itemPrice: json["item_price"],
        storePrice: json["store_price"],
        itemOfferPrice: json["item_offer_price"],
        itemPriceType: json["item_price_type"],
        itemCategoryId: json["item_category_id"],
        taxId: json["tax_id"],
        itemImageUrl: json["item_image_url"],
        itemStock: json["item_stock"],
        itemTags: json["item_tags"],
        status: json["status"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "store_id": storeId,
        "item_name": itemName,
        "item_type": itemType,
        "item_desc": itemDesc,
        "item_price": itemPrice,
        "store_price": storePrice,
        "item_offer_price": itemOfferPrice,
        "item_price_type": itemPriceType,
        "item_category_id": itemCategoryId,
        "tax_id": taxId,
        "item_image_url": itemImageUrl,
        "item_stock": itemStock,
        "item_tags": itemTags,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
      };
}

class StoreDetails {
  int storeId;
  int userId;
  String? name;
  String? mobile;
  String? email;
  String? address;
  String? city;
  String? state;
  String? country;
  String? logo;
  String? gstNo;
  String? panNo;
  String? terms;
  String? zipcode;
  String? frontImg;
  String? onlineVisibility;
  String? tags;
  int status;
  dynamic createdBy;
  dynamic createdDate;
  dynamic updatedBy;
  dynamic updatedDate;
  String? slug;
  int storeStatus;

  StoreDetails({
    required this.storeId,
    required this.userId,
    this.name,
    this.mobile,
    this.email,
    this.address,
    this.city,
    this.state,
    this.country,
    this.logo,
    this.gstNo,
    this.panNo,
    this.terms,
    this.zipcode,
    this.frontImg,
    this.onlineVisibility,
    this.tags,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    this.slug,
    required this.storeStatus,
  });

  factory StoreDetails.fromJson(Map<String, dynamic> json) => StoreDetails(
        storeId: json["store_id"],
        userId: json["user_id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        logo: json["logo"],
        gstNo: json["gst_no"],
        panNo: json["pan_no"],
        terms: json["terms"],
        zipcode: json["zipcode"],
        frontImg: json["front_img"],
        onlineVisibility: json["online_visibility"],
        tags: json["tags"],
        status: json["status"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
        slug: json["slug"],
        storeStatus: json["store_status"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "user_id": userId,
        "name": name,
        "mobile": mobile,
        "email": email,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "logo": logo,
        "gst_no": gstNo,
        "pan_no": panNo,
        "terms": terms,
        "zipcode": zipcode,
        "front_img": frontImg,
        "online_visibility": onlineVisibility,
        "tags": tags,
        "status": status,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
        "slug": slug,
        "store_status": storeStatus,
      };
}
