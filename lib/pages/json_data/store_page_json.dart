// drivers_data.dart

import 'dart:convert';

Future getStoreListJsonData() async {
  var result = {
    "status": "SUCCESS",
    "list": [
      {
        "id": 1,
        "type": "Non-Veg",
        "category": "Briyani",
        "dishname": "Chicken Biryani",
        "rating": "4.5",
        "reviewpersons": "125",
        "actualprice": "150.00",
        "discountprice": "100.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/store_biriyani.png",
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
        "reviewpersons": "125",
        "actualprice": "300.00",
        "discountprice": "200.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/store_kabab_img.png",
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
        "dishname": "Chicken Kebab",
        "rating": "4.5",
        "reviewpersons": "125",
        "actualprice": "300.00",
        "discountprice": "200.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/store_kabab_img.png",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 4,
        "type": "Non-Veg",
        "category": "Non-Veg Starters",
        "dishname": "Chicken Kebab",
        "rating": "4.0",
        "reviewpersons": "147",
        "actualprice": "200.00",
        "discountprice": "100.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/store_kabab_img.png",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 5,
        "type": "Non-Veg",
        "category": "Briyani",
        "dishname": "Chicken Briyani",
        "rating": "3.5",
        "reviewpersons": "235",
        "actualprice": "250.00",
        "discountprice": "150.00",
        "description": "Lorem ipsum dolor sit amet",
        "dishimage": "assets/images/store_biriyani.png",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      }
    ],
    "code": "206",
    "message": "Listed Successfully."
  };

  return result;
}
