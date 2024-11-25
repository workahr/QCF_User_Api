import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../pages/json_data/add_ratinglist_json.dart';
import '../pages/json_data/car_list_json.dart';
import '../pages/json_data/feedback_page_json.dart';
import '../pages/json_data/homescreen_json.dart';
import '../pages/json_data/home_carousel_json.dart';
import '../pages/json_data/locationpopup_json.dart';
import '../pages/json_data/myorder_page_json.dart';

import '../pages/json_data/order_preview_json.dart';

import '../pages/json_data/myprofile_json.dart';
import '../pages/json_data/myprofile_title_json.dart';
import '../pages/json_data/selectlocation_json.dart';

import '../pages/json_data/store_page_json.dart';
import '../pages/json_data/storerating_json.dart';

class NamFoodApiService {
  static String liveApiPath = AppConstants.apiBaseUrl;
  static String liveImgPath = AppConstants.imgBaseUrl;

  static String appApiPath = '';
  final client = http.Client();

//  static var headerData = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json ',
//   };

  static var headerData;

  NamFoodApiService() {
    getBearerToken();
  }
  getBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('auth_token');
    headerData = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $value',
    };
  }

//get all UserBranchList
  Future getAllUserBranchList() async {
    try {
      final url = Uri.parse('${liveApiPath}UserBranches/getUserBranchesList');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get Kpi chart data
  Future getKpiChartData(postData) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}SignumReport/KPIEvolution/KPIEvolutionAllDataBranchwiseVisual');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // get Overview chart data
  Future getOverviewChartData(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}SignumReport/RoleBasedKPIVisual');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // get festival
  Future getFilterFestivalData() async {
    try {
      final url =
          Uri.parse('${liveApiPath}ControlPanelSettingMasters/FestivalMaster');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // get Brands
  Future getFilterBrandsData(postData) async {
    try {
      final url =
          Uri.parse('${liveApiPath}ControlPanelSettingMasters/GeneralMaster');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // get Types
  Future getFilterTypesData(postData) async {
    try {
      final url =
          Uri.parse('${liveApiPath}ControlPanelSettingMasters/GeneralMaster');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // get Shape
  Future getFilterShapeData() async {
    try {
      final url = Uri.parse('${liveApiPath}Filter/FilterShape');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // get Shape
  Future getFilterFluorData() async {
    try {
      final url = Uri.parse('${liveApiPath}Filter/FilterFluor');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // get Salesman
  Future getFilterSalesmanData() async {
    try {
      final url =
          Uri.parse('${liveApiPath}ControlPanelSettingMasters/Salesman');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // post customer details
  Future inertCustomerDetails(postData) async {
    try {
      final url =
          Uri.parse('${liveApiPath}PosCustomerMaster/InsertCustomerMaster');
      final response = await client.post(url,
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData));
      if (response.statusCode == 200) {
        final json = response.body;
        return jsonDecode(json);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // update customer details
  Future updateCustomerDetails(postData) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}PosCustomerMaster/UpdateCustomerMaster/Code=${postData['CODE']}');
      final response = await client.put(url,
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData));
      if (response.statusCode == 200) {
        final json = response.body;
        return jsonDecode(json);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  handleError({message}) {
    throw Exception(message ?? 'Network Error');
  }

  // user  login
  Future userLogin(strUsername, strPassword) async {
    try {
      final url = Uri.parse('${liveApiPath}ValidatePassword?strusername=' +
          strUsername +
          '&strPassword=' +
          strPassword);
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // user Login With Otp
  Future userLoginWithOtp(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/mobilelogin');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));
      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        throw Exception(
            'Failed to login . Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

// carlist
  Future getcarList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/cars/getallcars');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

// save the car

  // Future saveCar(
  //     String apiCtrl, Map<String, dynamic> postData, imageFile) async {
  //   try {
  //     final url = Uri.parse(liveApiPath + apiCtrl);

  //     print('url $url');

  //     var headers = headerData;
  //     var request = http.MultipartRequest(
  //       'POST',
  //       url,
  //     );
  //     request.headers.addAll(headerData);

  //     for (var entry in postData.entries) {
  //       request.fields[entry.key] = entry.value.toString();
  //     }

  //     if (imageFile != null) {
  //       var image = await http.MultipartFile.fromPath('media', imageFile!.path);
  //       print(image);
  //       request.files.add(image);
  //     }

  //     request.headers.addAll(headers);
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       final json = await response.stream.bytesToString();
  //       return json;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     return e;
  //   }
  // }

//save car and update

  Future saveCar(
      String apiCtrl, Map<String, dynamic> postData, imageFile) async {
    try {
      final url = Uri.parse(liveApiPath + apiCtrl);

      var headers = headerData;
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      request.headers.addAll(headerData);

      for (var entry in postData.entries) {
        request.fields[entry.key] = entry.value.toString();
      }
      if (imageFile != null) {
        var image = await http.MultipartFile.fromPath('media', imageFile!.path);
        request.files.add(image);
      }
      request.headers.addAll(headers);
      var response = await request.send();
      if (response.statusCode == 200) {
        final json = await response.stream.bytesToString();
        return json;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // delete CarById
  Future deleteCarById(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/cars/delete-cars');
      final response = await client.delete(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  //get Carbyid
  Future getCarById(id) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/cars/list-cars-ById?id=$id');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // update Car
  // Future updatecar(postData, imageFile) async {
  //   try {
  //     final url = Uri.parse('${liveApiPath}v1/cars/update-cars');
  //     final response = await client.post(url,
  //         headers: headerData, body: jsonEncode(postData));
  //     var request = http.MultipartRequest(
  //       'POST',
  //       url,
  //     );
  //     if (imageFile != null) {
  //       var image = await http.MultipartFile.fromPath('media', imageFile!.path);
  //       print(image);
  //       request.files.add(image);
  //     }

  //     if (response.statusCode == 200) {
  //       final json = response.body;
  //       return json;
  //     } else {
  //       print('error');
  //       throw Exception(
  //           'Failed. Status code: ${response.statusCode} ${response.toString()}');
  //     }
  //   } catch (e) {
  //     print('catcherror ${e}');
  //     return e;
  //   }
  // }

  // driverlist
  Future getdriverList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/user_details/getalluser_details');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // booking details by customer

  // get all booking
  Future getbookingbycustomer() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/booking/list-booking-ByUser');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  //booking  update by driver id and car id

  Future updatebookingbydriverid(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/booking/update-booking');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror ${e}');
      return e;
    }
  }

  //save the Booking

  Future saveBooking(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/booking/create-booking');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

// cancle update
  Future updatecancelbooking(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/booking/booking-cancel');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get all booking
  Future getbookingList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/booking/getallbooking');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get booking by id

  Future getBookingById(id) async {
    try {
      final url =
          Uri.parse('${liveApiPath}v1/booking/list-booking-ById?id=$id');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get kilometer for booking

  Future getkilometerByfromto(from, to) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/booking/calculate-distance?from_location=$from&to_location=$to');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // calculate bookinfg charges
  Future getboookingchargeBykmdate(
      totalkm, Fromdate, Todate, selectedCar) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/booking/calculate-booking_charge?total_distance=$totalkm&from_datetime=$Fromdate&to_datetime=$Todate&car_id=$selectedCar');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // thirdparty details Add

  Future saveThirdParty(postData) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/rental_owner_details/create-rental_owner_details');
      print("test1 ");
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      print("test2 ");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // delete thirdpartyById
  Future deleteThirdpartyById(postData) async {
    print('thirdparty delete test $postData');
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/rental_owner_details/delete-rental_owner_details');
      final response = await client.delete(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  //get Thirdpartybyid
  Future getThirdpartyById(id) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/rental_owner_details/list-rental_owner_details-ById?id=$id');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // update ThirdParty
  Future updatethirdparty(postData) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/rental_owner_details/update-rental_owner_details');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror ${e}');
      return e;
    }
  }

  Future getthirdpartyList() async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/rental_owner_details/getallrental_owner_details');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // Driver Panel get all driver mytrip

  Future getmytripByidList(id) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/user_details/driver-trip-list?driver_id=$id');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

// Save Vehicalstatus

  Future savevehicalstatus(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/cars/update-vehicle_status');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror ${e}');
      return e;
    }
  }

  // save the Expenses

  Future saveexpenses(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/expenses/create-expenses');
      print("test1 ");
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      print("test2 ");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // Expenses list
  Future getexpensesList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/expenses/getallexpenses');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // delete ExpensesById
  Future deleteExpensesById(postData) async {
    print('driver delete test $postData');
    try {
      final url = Uri.parse('${liveApiPath}v1/expenses/delete-expenses');
      final response = await client.delete(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  //get expenses by id

  Future getExpensesById(id) async {
    try {
      final url =
          Uri.parse('${liveApiPath}v1/expenses/list-expenses-ById?id=$id');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // expenses update

  Future updateexpenses(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/expenses/update-expenses');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror ${e}');
      return e;
    }
  }

  // Start Kilomter  update

  Future updatestartkilomter(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/booking/startkm-endkm');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror ${e}');
      return e;
    }
  }

// save the Driver

  Future saveDriver(String apiCtrl, Map<String, dynamic> postData) async {
    try {
      final url = Uri.parse(liveApiPath + apiCtrl);

      print('url $url');

      var headers = headerData;
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      request.headers.addAll(headerData);

      for (var entry in postData.entries) {
        request.fields[entry.key] = entry.value.toString();
      }

      // if (imageFile != null) {
      //   var image = await http.MultipartFile.fromPath('media', imageFile!.path);
      //   print(image);
      //   request.files.add(image);
      // }

      request.headers.addAll(headers);
      var response = await request.send();
      if (response.statusCode == 200) {
        final json = await response.stream.bytesToString();
        return json;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // delete DriverById
  Future deleteDriverById(postData) async {
    print('driver delete test $postData');
    try {
      final url =
          Uri.parse('${liveApiPath}v1/user_details/delete-user_details');
      final response = await client.delete(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  //get Driverbyid
  Future getDriverById(id) async {
    try {
      final url = Uri.parse(
          '${liveApiPath}v1/user_details/list-user_details-ById?id=$id');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // update Driver
  Future updatedriver(postData) async {
    try {
      final url =
          Uri.parse('${liveApiPath}v1/user_details/update-user_details');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror ${e}');
      return e;
    }
  }

  // get all employee details
  Future employeeDetails(strUsername) async {
    try {
      final url =
          Uri.parse('${liveApiPath}EmployeeDetails?EMPMST_NAME=' + strUsername);
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // get daily Status
  Future getAllDailyStatus(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}ComOverallReports');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  //get all
  Future get(apiUrl) async {
    try {
      final url = Uri.parse(liveApiPath + apiUrl);
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get all Leave Balance
  Future getAllLeaveBalance() async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeDetails?EMPMST_NAME');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  //get all LeaveApproval
  Future getAllLeaveApproval() async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComLeave');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // update customer details
  Future requestAction(postData) async {
    try {
      final url =
          Uri.parse('${liveApiPath}EmployeeComLeave?MID=${postData['MID']}');
      final response = await client.put(url,
          headers: headerData, body: jsonEncode(postData));
      if (response.statusCode == 200) {
        final json = response.body;
        return jsonDecode(json);
      } else {
        print('error response $response');
        throw Exception(response.toString());
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // Save EntryWorkFromHome
  Future saveEntryWorkFromHome(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComWorkfromhome');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // Save EntryLeave
  Future saveEntryLeave(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComLeave');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // Save Entry Permission
  Future saveEntryPermission(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComPermission');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // Save Entry Working Extra
  Future saveEntryWorkingExtra(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComWorkingExtra');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // Save Entry Client Visit
  Future saveEntryClientVisit(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComClientLocation');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // get Overview chart data
  Future getAllEntryList(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}ComOverallReports');
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // update Entry WorkFromHome
  Future updateEntryWorkFromHome(mid, postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComWorkfromhome?MID=$mid');

      final response = await client.put(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror $e');
      return e;
    }
  }

// delete WorkFromHomeById
  Future delete(apiUrl) async {
    try {
      final url = Uri.parse(liveApiPath + apiUrl);
      //final url = Uri.parse('${liveApiPath}EmployeeComWorkfromhome?MID=$mid');
      final response = await client.delete(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // update Entry Permission
  Future updateEntryPermission(mid, postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComPermission?MID=$mid');

      final response = await client.put(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror $e');
      return e;
    }
  }

// delete PermissionById
  Future deletePermissionById(mid) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComPermission?MID=$mid');
      final response = await client.delete(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  // update Entry Leave
  Future updateEntryLeave(mid, postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComLeave?MID=$mid');

      final response = await client.put(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror $e');
      return e;
    }
  }

  // update Entry WorkingExtra
  Future updateEntryWorkingExtra(mid, postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComWorkingExtra?MID=$mid');

      final response = await client.put(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror $e');
      return e;
    }
  }

// update Entry ClientVisit
  Future updateEntryClientVisit(mid, postData) async {
    try {
      final url = Uri.parse('${liveApiPath}EmployeeComClientLocation?MID=$mid');

      final response = await client.put(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final json = response.body;
        return json;
      } else {
        print('error');
        throw Exception(
            'Failed. Status code: ${response.statusCode} ${response.toString()}');
      }
    } catch (e) {
      print('catcherror $e');
      return e;
    }
  }

  // driverlist
  // Future getdriverList() async {
  //   try {
  //     final url = Uri.parse('${liveApiPath}v1/user_details/getalluser_details');
  //     final response = await client.get(
  //       url,
  //       headers: headerData,
  //     );
  //     if (response.statusCode == 200) {
  //       return response.body;
  //     } else {
  //       return response;
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to retrieve driver data: $e');
  //   }
  // }

  Future getstoreList() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getStoreListJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve driver data: $e');
    }
  }

  //ecomAddtoCart

  Future getdashbordlist() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await gethomedashboardPageJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }

  //Homepage_Carousel

  Future gethomecarousel() async {
    try {
      var result = await getHomeCarouselJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve Carousel: $e');
    }
  }

  //nam_myorderpage

  Future getmyorderpage() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getMyOrderJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve MyOrder: $e');
    }
  }

  //ecomAddtoCart

  Future getstoredishlist() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getStoreListJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }

  Future getOrderPreviewlist() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getOrderPreviewListJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }

  Future getAddRatingList() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getAddRatingJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }

  // feedback List

  Future getfeedbacklist() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getfeedbackPageJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }

// // Cart List Api
//   Future getCartList() async {
//     try {
//       // Create a list of DriversList with hardcoded data

//       var result = await getCartListJsonData();
//       return jsonEncode(result);
//     } catch (e) {
//       // Handle any errors
//       throw Exception('Failed to retrieve AddtoCart: $e');
//     }
//   }

  // store Rating

  Future getstoreratinglist() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getstoreratingPageJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }
  // myprofile

  Future getmyprofile() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getMyProfileJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }
  // ecomselectlocation

  Future getselectlocation() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getSelectLocationJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }
  // ecommyProfiletitle

  Future getmyprofiletitle() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getMyProfileTitleJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }
  // ecomlocationpopup

  Future getlocationpopup() async {
    try {
      // Create a list of DriversList with hardcoded data

      var result = await getLocationPopupJsonData();
      return jsonEncode(result);
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to retrieve AddtoCart: $e');
    }
  }

// get All Banners image
  Future getBannerList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/getallbanner');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get All Dashborad Store List
  Future getdashStoreList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/getallstore');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get All My Orders List
  Future getMyOrderList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/getallorder');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // get All Cart List
  Future getCartList() async {
    try {
      final url = Uri.parse('${liveApiPath}v1/getcart');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // add quantity for products
  Future addQuantity(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/addquantity');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('error response $response');
        throw Exception(response.toString());
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // remove quantity for products
  Future removeQuantity(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/removequantity');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('error response $response');
        throw Exception(response.toString());
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // Delete Cart
  Future deleteCart(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/deleteitem');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('error response $response');
        throw Exception(response.toString());
      }
    } catch (e) {
      print('error $e');
      handleError();
    }
  }

  // User Store API

// store deatil list

  Future getstoredetailmenuList(id) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/getstoredetails?store_id=$id');
      final response = await client.get(
        url,
        headers: headerData,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

// Store page Add Qty

  Future addquantity(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/addquantity');
      print("test1 ");
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      print("test2 ");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // Store page Remove Qty

  Future removequantity(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/removequantity');
      print("test1 ");
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      print("test2 ");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }

  // Store page Delete Qty

  Future deletequantity(postData) async {
    try {
      final url = Uri.parse('${liveApiPath}v1/deleteitem');
      print("test1 ");
      final response = await client.post(
        url,
        headers: headerData,
        body: jsonEncode(postData),
      );
      print("test2 ");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }
}
