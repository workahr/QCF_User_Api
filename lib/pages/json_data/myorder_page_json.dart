Future getMyOrderJsonData() async {
  var result = {
    "status": "SUCCESS",
    "code": "200",
    "message": "Listed Successfully",
    "list": [
      {
        "id": 1,
        "orderid": "0012345",
        "items": "12",
        'orderstatus': 'On Delivery',
        "DeliveryDate": "20-Oct-2024",
        "Orderdetails": [
          {
            "OrderPlacedDate": "12:02 AM",
            "OrderConfirmedDate": "12:02 AM",
            "DeliveryTime": "12:02 AM",
          }
        ],
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": DateTime.now().toIso8601String(),
        "updated_by": 102,
        "updated_date": DateTime.now().toIso8601String(),
        "user_id": 1001,
        "vehicle_id": 201,
        "license_number": "XYZ123456",
        "license_expiry": DateTime(2025, 12, 31).toIso8601String(),
        "address": "123 Main St, City",
      },
      {
        "id": 2,
        "orderid": "0012345",
        "items": "12",
        'orderstatus': 'Completed',
        "DeliveryDate": "20-Oct-2024",
        "Orderdetails": [
          {
            "OrderPlacedDate": "12:02 AM",
            "OrderConfirmedDate": "12:02 AM",
            "DeliveryTime": "12:02 AM",
          }
        ],
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": DateTime.now().toIso8601String(),
        "updated_by": 102,
        "updated_date": DateTime.now().toIso8601String(),
        "user_id": 1001,
        "vehicle_id": 201,
        "license_number": "XYZ123456",
        "license_expiry": DateTime(2025, 12, 31).toIso8601String(),
        "address": "123 Main St, City",
      },
      {
        "id": 3,
        "orderid": "0012345",
        "items": "12",
        'orderstatus': 'Completed',
        "DeliveryDate": "20-Oct-2024",
        "Orderdetails": [
          {
            "OrderPlacedDate": "12:02 AM",
            "OrderConfirmedDate": "12:02 AM",
            "DeliveryTime": "12:02 AM",
          }
        ],
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": DateTime.now().toIso8601String(),
        "updated_by": 102,
        "updated_date": DateTime.now().toIso8601String(),
        "user_id": 1001,
        "vehicle_id": 201,
        "license_number": "XYZ123456",
        "license_expiry": DateTime(2025, 12, 31).toIso8601String(),
        "address": "123 Main St, City",
      },
      {
        "id": 4,
        "orderid": "0012345",
        "items": "12",
        'orderstatus': 'On Delivery',
        "DeliveryDate": "20-Oct-2024",
        "Orderdetails": [
          {
            "OrderPlacedDate": "12:02 AM",
            "OrderConfirmedDate": "12:02 AM",
            "DeliveryTime": "12:02 AM",
          }
        ],
        "status": 1,
        "active": 1,
        "created_by": 101,
        "created_date": DateTime.now().toIso8601String(),
        "updated_by": 102,
        "updated_date": DateTime.now().toIso8601String(),
        "user_id": 1001,
        "vehicle_id": 201,
        "license_number": "XYZ123456",
        "license_expiry": DateTime(2025, 12, 31).toIso8601String(),
        "address": "123 Main St, City",
      },
    ]
  };

  return result;
}
