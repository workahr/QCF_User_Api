// drivers_data.dart

import 'dart:convert';

Future getMyProfileTitleJsonData() async {
  var result = {
    "status": "SUCCESS",
    "list": [
      {
        "id": 1,
        "icon": "assets/images/address_black.png",
        "title": "Address",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 2,
        "icon": "assets/images/feedback.png",
        "title": "Feedback & Complaints",
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": null,
        "updated_by": 102,
        "updated_date": null
      },
      {
        "id": 3,
        "icon": "assets/images/logout.png",
        "title": "Log out",
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
