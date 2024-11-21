// drivers_data.dart

import 'dart:convert';

Future getSelectLocationJsonData() async {
  var result = {
    "status": "SUCCESS",
    "list": [
      {
        "id": 1,
        "icon": "assets/images/home_red.png",
        "type": "Home",
        "address":
            "No 37 Paranjothi Nagar Thalakoidi, velour Nagar Trichy-620005, Landmark-Andavan collage",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 2,
        "icon": "assets/images/work_red.png",
        "type": "Work",
        "address":
            "No 37 Paranjothi Nagar Thalakoidi, velour Nagar Trichy-620005, Landmark-Andavan collage",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 3,
        "icon": "assets/images/home_red.png",
        "type": "Home 2",
        "address":
            "No 37 Paranjothi Nagar Thalakoidi, velour Nagar Trichy-620005, Landmark-Andavan collage",
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
