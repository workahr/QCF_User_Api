// drivers_data.dart

import 'dart:convert';

import 'package:namfood/constants/app_assets.dart';

Future getCartListJsonData() async {
  var result = {
    "status": "SUCCESS",
    "list": [
      {
        "id": 1,
        "type": "Non-Veg",
        "category": "Briyani",
        "dishname": "Chicken Biryani",
        "rating": "4.5",
        "quantity_price": "300",
        "qty": 3,
        "reviewpersons": "125",
        "actualprice": "150",
        "discountprice": "100.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/cart_biriyani_img.png",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 2,
        "type": "Non-Veg",
        "category": "Briyani",
        "dishname": "Chicken Kebab",
        "rating": "4.5",
        "qty": 6,
        "quantity_price": "500",
        "reviewpersons": "125",
        "actualprice": "300",
        "discountprice": "200.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/cart_biriyani_img.png",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 3,
        "type": "Non-Veg",
        "category": "Non-Veg Starters",
        "dishname": "Mutton Biriyani",
        "rating": "4.5",
        "qty": 7,
        "quantity_price": "600",
        "reviewpersons": "125",
        "actualprice": "300",
        "discountprice": "200.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/cart_biriyani_img.png",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
    ],
    "code": "206",
    "message": "Listed Successfully."
  };

  return result;
}
