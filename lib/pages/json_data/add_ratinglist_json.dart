// drivers_data.dart

import 'dart:convert';

import 'package:namfood/constants/app_assets.dart';

Future getAddRatingJsonData() async {
  var result = {
    "status": "SUCCESS",
    "list": [
      {
        "id": 1,
        "store_name": "Grill Chicken Arabian Restaurant",
        "store_rating": 4,
        "person_rating": 3,
        "qty": "Qty-5",
        "dishimage": "assets/images/cart_biriyani_img.png",
        "dishes": [
          {"name": " Biriyani", "rating": 3},
          {"name": " Kabab", "rating": 4},
          {"name": " Biriyani", "rating": 5}
        ],
        "delivery_person": "Barani",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": "2024-11-12 10:40:29",
        "updated_by": 102,
        "updated_date": "2024-11-12 10:40:29"
      },
    ],
    "code": "206",
    "message": "Listed Successfully."
  };

  return result;
}
