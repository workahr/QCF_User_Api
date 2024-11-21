// drivers_data.dart

import 'dart:convert';

Future getMyProfileJsonData() async {
  var result = {
    "status": "SUCCESS",
    "list": [
      {
        "id": 1,
        "icon": "assets/images/Home_black.png",
        "type": "Home",
        "address":
            "No 37 Paranjothi Nagar Thalakoidi, velour Nagar Trichy-620005, Landmark-Andavan collage",
        "contact": "Contact : 1234567890",
        "currentlocation": "Yes",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 2,
        "icon": "assets/images/work_black.png",
        "type": "Work",
        "address":
            "No 37 Paranjothi Nagar Thalakoidi, velour Nagar Trichy-620005, Landmark-Andavan collage",
        "contact": "Contact : 1234567890",
        "currentlocation": "No",
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
