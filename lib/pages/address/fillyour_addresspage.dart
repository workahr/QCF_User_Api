import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namfood/constants/app_assets.dart';
import 'package:namfood/pages/HomeScreen/home_screen.dart';
import 'package:namfood/pages/address/address_list_model.dart';
import 'package:namfood/pages/maincontainer.dart';
import 'package:namfood/widgets/heading_widget.dart';
import 'package:namfood/widgets/outline_btn_widget.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_autocomplete_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/sub_heading_widget.dart';
import 'addaddress_model.dart';
import 'address_edit_model.dart';
import 'address_update_model.dart';
import 'addresspage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'get_latlog_address.dart';
import 'mainlocation_list.dart';
import 'sublocation_list.dart';

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';

class FillyourAddresspage extends StatefulWidget {
  int? addressId;
  double? lat;
  double? long;
  FillyourAddresspage({super.key, this.addressId, this.lat, this.long});

  @override
  State<FillyourAddresspage> createState() => _FillyourAddresspageState();
}

class _FillyourAddresspageState extends State<FillyourAddresspage> {
  final NamFoodApiService apiService = NamFoodApiService();
  final GlobalKey<FormState> addressForm = GlobalKey<FormState>();

  int? _selectedCheckboxIndex;
  int _selectedIndex = 0;
  int? _selectedDefaultIndex;

  String _selectedAddressType = 'Home';

  TextEditingController contactnoController = TextEditingController();
  TextEditingController lankmarkController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController logController = TextEditingController();

  String? selectedmainlocation;
  int? selectedmainlocationId;

  selectedmainlocationArray() {
    List result;

    if (MainLocationListdata!.isNotEmpty) {
      result = MainLocationListdata!
          .where((element) => element.id == selectedmainlocationId)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          print("result a 2 drop:$result");
          selectedmainlocationedit = result[0];
        });
      } else {
        setState(() {
          selectedmainlocationedit = null;
        });
      }
    } else {
      setState(() {
        print('selectedVisitPurposeArr empty');

        selectedmainlocationedit = null;
      });
    }
  }

  var selectedmainlocationedit;

  List<MainLocation>? MainLocationListdata;
  List<MainLocation>? MainLocationListdataAll;
  bool isLoading = false;

  Future getallmainlocationList() async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });
    await apiService.getBearerToken();
    var result = await apiService.getallmainlocationList();
    var response = mainLocationListmodelFromJson(result);
    if (response.status.toString() == 'SUCCESS') {
      setState(() {
        MainLocationListdata = response.list;
        MainLocationListdataAll = MainLocationListdata;
        isLoading = false;
        if (widget.addressId != null) {
          selectedmainlocationArray();
        }
      });
    } else {
      setState(() {
        MainLocationListdata = [];
        MainLocationListdataAll = [];
        isLoading = false;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  String? selectedsublocation;
  int? selectedsublocationId;

  selectedsublocationArray() {
    List result;

    if (SubLocationListdata!.isNotEmpty) {
      result = SubLocationListdata!
          .where((element) => element.id == selectedsublocationId)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          print("result a 2 drop:$result");
          selectedsublocationedit = result[0];
        });
      } else {
        setState(() {
          selectedsublocationedit = null;
        });
      }
    } else {
      setState(() {
        print('selectedVisitPurposeArr empty');

        selectedsublocationedit = null;
      });
    }
  }

  var selectedsublocationedit;

  List<SubLocation>? SubLocationListdata;
  List<SubLocation>? SubLocationListdataAll;
  bool isLoadingsub = false;

  Future getallsublocationList(int? mainid) async {
    await apiService.getBearerToken();
    setState(() {
      isLoading = true;
    });
    await apiService.getBearerToken();
    var result = await apiService.getallsublocationbymainList(mainid);
    var response = subLocationListmodelFromJson(result);
    if (response.status.toString() == 'SUCCESS') {
      setState(() {
        SubLocationListdata = response.list;
        SubLocationListdataAll = SubLocationListdata;
        isLoading = false;
        if (widget.addressId != null) {
          selectedsublocationArray();
        }
      });
    } else {
      setState(() {
        SubLocationListdata = [];
        SubLocationListdataAll = [];
        isLoading = false;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  final Map<String, bool> _defaultStatus = {
    'Home': false,
    'Work': false,
    'Other': false,
  };

  var selectedstateArr;
  String? selectedstate;
  List referList = [
    {"name": "Tamil Nadu", "value": 1},
    // {"name": "No", "value": 2},
  ];
  var selectedcityArr;
  String? selectedcity;
  List refercityList = [
    {"name": "Trichy", "value": 1},
    // {"name": "No", "value": 2},
  ];

  // Method to build address form
  Widget _buildAddressForm(String type) {
    List<Widget> fields = [
      // CustomeTextField(

      //   borderColor: AppColors.grey1,
      //   labelText: 'Contact Number',
      //   width: MediaQuery.of(context).size.width,
      // ),

      // GestureDetector(
      //     onTap: () {
      //       setState(() {
      //         // _getCurrentPosition();
      //       });
      //     },
      //     child: OutlineBtnWidget(
      //       borderColor: AppColors.red,
      //       titleColor: AppColors.red,
      //       icon: Icons.my_location,
      //       iconColor: AppColors.red,
      //       title: "Mark a Place In Map",
      //       height: 50,
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => MapScreen(),
      //           ),
      //         );
      //       },
      //     )),
      SizedBox(
        height: 10,
      ),
      CustomeTextField(
        control: address1Controller,
        borderColor: AppColors.grey1,
        labelText: 'Address 1',
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        control: address2Controller,
        borderColor: AppColors.grey1,
        labelText: 'Address 2',
        width: MediaQuery.of(context).size.width,
      ),
      CustomeTextField(
        control: lankmarkController,
        borderColor: AppColors.grey1,
        labelText: 'Land Mark',
        width: MediaQuery.of(context).size.width,
      ),
      if (MainLocationListdata != null)
        CustomAutoCompleteWidget(
          width: MediaQuery.of(context).size.width / 1.1,
          selectedItem: selectedmainlocationedit,
          labelText: 'Select Main Location',
          labelField: (item) => item.name,
          onChanged: (value) {
            selectedmainlocation = value.name;
            selectedmainlocationId = value.id;
            print("mainlocation id$selectedmainlocationId");
            getallsublocationList(selectedmainlocationId);
          },
          valArr: MainLocationListdata,
        ),
      if (SubLocationListdata != null)
        CustomAutoCompleteWidget(
          width: MediaQuery.of(context).size.width / 1.1,
          selectedItem: selectedsublocationedit,
          labelText: 'Select Sub Location',
          labelField: (item) => item.name,
          onChanged: (value) {
            selectedsublocation = value.name;
            selectedsublocationId = value.id;
            print("sublocation id$selectedsublocationId");
            //  getallsublocationList(selectedsublocationId);
          },
          valArr: SubLocationListdata,
        ),
      // CustomeTextField(
      //   control: cityController,
      //   borderColor: AppColors.grey1,
      //   labelText: 'City',
      //   lines: 1,
      //   width: MediaQuery.of(context).size.width,
      // ),
      CustomAutoCompleteWidget(
        width: MediaQuery.of(context).size.width / 1.1,
        selectedItem: selectedcityArr,
        labelText: 'City',
        labelField: (item) => item["name"],
        onChanged: (value) {
          selectedcity = value["name"];
          print(selectedcity);
          // if (selectedyes == 'No') {
          //   selectedThirdpartyId == 0;
          //   selectedThirdParty == '';
          // }
        },
        valArr: refercityList,
      ),
      // CustomeTextField(
      //   control: stateController,
      //   borderColor: AppColors.grey1,
      //   labelText: 'State',
      //   lines: 1,
      //   width: MediaQuery.of(context).size.width,
      // ),
      CustomAutoCompleteWidget(
        width: MediaQuery.of(context).size.width / 1.1,
        selectedItem: selectedstateArr,
        labelText: 'State',
        labelField: (item) => item["name"],
        onChanged: (value) {
          selectedstate = value["name"];
          print(selectedstate);
          // if (selectedyes == 'No') {
          //   selectedThirdpartyId == 0;
          //   selectedThirdParty == '';
          // }
        },
        valArr: referList,
      ),
      CustomeTextField(
        control: postController,
        borderColor: AppColors.grey1,
        labelText: 'Post Code',
        type: const TextInputType.numberWithOptions(),
        inputFormaters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?\.?\d{0,11}'))
        ],
        lines: 1,
        width: MediaQuery.of(context).size.width,
      ),
      Row(
        children: [
          Checkbox(
            side: BorderSide(color: AppColors.grey, width: 2),
            activeColor: AppColors.red, // Color when checked
            checkColor: Colors.white, // Tick mark color
            value: _defaultStatus[type],
            onChanged: (bool? value) {
              setState(() {
                _defaultStatus[type] = value ?? false; // Update status
                print('Default Address for $type: ${_defaultStatus[type]}');
              });
            },
          ),
          SubHeadingWidget(
            title: 'Set as default address',
            color: AppColors.red,
          )
        ],
      ),
    ];

    // if (type == 'Other') {
    //   fields.insert(
    //     0,
    //     CustomeTextField(
    //       borderColor: AppColors.grey1,
    //       labelText: 'Save As',
    //       width: MediaQuery.of(context).size.width,
    //     ),
    //   );
    // }

    return Column(children: fields);
  }

  Future saveaddress() async {
    if (addressForm.currentState!.validate()) {
      Map<String, dynamic> postData = {
        "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
        "type": _selectedAddressType.toString(),
        "address": address1Controller.text,
        "address_line_2": address2Controller.text,
        "city": "Trichy", //selectedcity,
        "state": selectedstate,
        "postcode": postController.text,
        "landmark": lankmarkController.text,
        "main_location_id": selectedmainlocationId,
        "sub_location_id": selectedsublocationId,
        "latitude": widget.lat, //latController.text,
        "longitude": widget.long //logController.text,
      };
      print('postData $postData');

      var result = await apiService.saveaddress(postData);
      print('result $result');
      Addaddressmodel response = addaddressmodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        // showInSnackBar(context, response.message.toString());

        // Navigator.pushNamedAndRemoveUntil(
        //     context, '/home', ModalRoute.withName('/home'));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainContainer(initialPage: 2),
          ),
        );
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  EditAddressList? addressDetails;

  Future getAddressById() async {
    await apiService.getBearerToken();

    var result = await apiService.getAddressById(widget.addressId);
    AdddressEditmodel response = adddressEditmodelFromJson(result);
    print(response);
    if (response.status.toString() == 'SUCCESS') {
      setState(() {
        addressDetails = response.list;
        _selectedAddressType = (addressDetails!.type ?? '').toString();

        _defaultStatus[_selectedAddressType] =
            addressDetails!.defaultAddress == 1;

        address1Controller.text = addressDetails!.address ?? '';
        address2Controller.text = addressDetails!.addressLine2 ?? '';
        selectedsublocationId = addressDetails!.sub_location_id;
        selectedmainlocationId = addressDetails!.main_location_id;
        print(addressDetails!.main_location_id);
        cityController.text = addressDetails!.city ?? '';
        stateController.text = addressDetails!.state ?? '';
        postController.text = (addressDetails!.postcode ?? '').toString();
        lankmarkController.text = addressDetails!.landmark ?? '';
      });
    } else {
      showInSnackBar(context, "Data not found");
      //isLoaded = false;
    }
  }

  @override
  void initState() {
    super.initState();
    refresh();
    print('AddressById :' + widget.addressId.toString());
    selectedstateArr =
        referList.firstWhere((item) => item["name"] == "Tamil Nadu");
    selectedstate = selectedstateArr["name"];
    selectedcityArr =
        refercityList.firstWhere((item) => item["name"] == "Trichy");
    selectedcity = selectedcityArr["name"];
  }

  refresh() async {
    if (widget.addressId != null) {
      await getAddressById();
    }
    getallmainlocationList();
    // getallsublocationList(0);
  }

  Future updateaddress() async {
    await apiService.getBearerToken();
    if (addressForm.currentState!.validate()) {
      Map<String, dynamic> postData = {
        "id": widget.addressId,
        "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
        "type": _selectedAddressType.toString(),
        "address": address1Controller.text,
        "address_line_2": address2Controller.text,
        "city": "Trichy",
        "state": stateController.text,
        "postcode": postController.text,
        "landmark": lankmarkController.text,
        "main_location_id": selectedmainlocationId,
        "sub_location_id": selectedsublocationId,
        "latitude": widget.lat, //latController.text,
        "longitude": widget.long //logController.text,
      };
      print("updateaddressupdate $postData");
      var result = await apiService.updateaddress(postData);

      AdddressUpdatemodel response = adddressUpdatemodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        print("test1");
        // showInSnackBar(context, response.message.toString());
        //  Navigator.pop(context, {'update': true});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainContainer(initialPage: 2),
          ),
        );
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  late GoogleMapController _mapController;
  LatLng _initialPosition =
      LatLng(37.7749, -122.4194); // Default: San Francisco
  late LatLng _currentPosition = _initialPosition;
  String address = "";
  Future<void> _getCurrentLocation() async {
    // Check and request permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied. Enable them in settings.');
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _initialPosition = _currentPosition;

      _getAddressFromLatLng(position.latitude, position.longitude);
    });

    // Move camera to the current position
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 14.0),
      ),
    );
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        print(place);
        setState(() {
          address1Controller.text = (place.name ?? "").toString();
          address2Controller.text = (place.street ?? "").toString();
          lankmarkController.text = (place.subLocality ?? "").toString();
          cityController.text = (place.locality ?? "").toString();
          stateController.text = (place.administrativeArea ?? "").toString();
          postController.text = (place.postalCode ?? "").toString();
          latController.text = latitude.toString();
          logController.text = longitude.toString();
          print("lat : $latitude");
          address =
              "${place.street}, ${place.locality}, ${place.subLocality} ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _currentPosition = position;
    });
    _getAddressFromLatLng(position.latitude, position.longitude);
  }

  // Future<void> updateaddress() async {
  //   await apiService.getBearerToken();
  //   if (addressForm.currentState!.validate()) {
  //     Map<String, dynamic> postData = {
  //       "id": widget.addressId,
  //       "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
  //       "type": _selectedAddressType.toString(),
  //       "address": address1Controller.text,
  //       "address_line_2": address2Controller.text,
  //       "city": cityController.text,
  //       "state": stateController.text,
  //       "postcode": postController.text,
  //       "landmark": lankmarkController.text,
  //     };
  //     print("updateAddress $postData");

  //     try {
  //       var result = await apiService.updateaddress(postData);
  //       AdddressUpdatemodel response = adddressUpdatemodelFromJson(result);

  //       if (response.status.toString() == 'SUCCESS') {
  //         if (mounted) {
  //           // Ensure the widget is still active
  //           showInSnackBar(context, response.message.toString());

  //           // Replace Navigator.push with Navigator.pushReplacement for better flow
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Addresspage(),
  //             ),
  //           );
  //         }
  //       } else {
  //         if (mounted) {
  //           // Ensure the widget is still active
  //           print(response.message.toString());
  //           showInSnackBar(context, response.message.toString());
  //         }
  //       }
  //     } catch (e) {
  //       if (mounted) {
  //         // Ensure the widget is still active
  //         showInSnackBar(context, "Error occurred: $e");
  //       }
  //       print('Error occurred: $e');
  //     }
  //   } else {
  //     if (mounted) {
  //       // Ensure the widget is still active
  //       showInSnackBar(context, "Please fill all fields");
  //     }
  //   }
  // }

  // String? _currentAddress;
  // Position? _currentPosition;

  // Future<PermissionStatus> _handleLocationPermission() async {
  //   final PermissionStatus status = await Permission.location.request();
  //   return status;
  // }

  // Future<void> _getCurrentPosition() async {
  //   final PermissionStatus permissionStatus = await _handleLocationPermission();
  //   // Map<Permission, PermissionStatus> statuses = await [
  //   //   Permission.location,
  //   // ].request();
  //   print("statuses Permission" + permissionStatus.toString());
  //   if (permissionStatus == PermissionStatus.granted) {
  //     //final PermissionStatus statuses1 = await _handleLocationPermission1();
  //     PermissionStatus statuses1 = await Permission.locationAlways.request();
  //     print("statuses1 Permission" + statuses1.toString());
  //     if (statuses1 == PermissionStatus.granted) {
  //       print("statuses2 Permission" + statuses1.toString());
  //       await Geolocator.getCurrentPosition(
  //               desiredAccuracy: LocationAccuracy.high)
  //           .then((Position position) async {
  //         setState(() => _currentPosition = position);
  //         _getAddressFromLatLng(_currentPosition!);
  //         // print('lattitude: ' +
  //         //     _currentPosition.latitude.toString() +
  //         //     'Longitude : ' +
  //         //     _currentPosition.latitude.toString());
  //         // return position;
  //       }).catchError((e) {
  //         debugPrint(e);
  //       });
  //     } else {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return new AlertDialog(
  //               title: new Text("Alert"),
  //               content: new Text(
  //                   "Please Select \"Allow all the time\" to continue..."),
  //               actions: <Widget>[
  //                 new ElevatedButton(
  //                   child: new Text("OK"),
  //                   onPressed: () async {
  //                     Navigator.of(context).pop();
  //                     final PermissionStatus statuses4 =
  //                         await Permission.locationAlways.request();
  //                     print("statuses3 Permission" + statuses4.toString());
  //                   },
  //                 ),
  //               ],
  //             );
  //           });
  //     }
  //   } else {
  //     print("statuses4 Permission widget");
  //   }
  // }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(position.latitude, position.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _currentAddress =
  //           '${place.street} ${place.thoroughfare} ${place.subThoroughfare},${place.subLocality},${place.locality},${place.administrativeArea} ${place.subAdministrativeArea},${place.postalCode}, ${place.country}${'(' + place.isoCountryCode! + ')'}';
  //       print('Address : ' + _currentAddress!);
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey3,
        title: Text('Fill your address'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: addressForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //new map
                // SizedBox(
                //   width: 500.0,
                //   height: 500.0,
                //   child: GoogleMap(
                //     onMapCreated: (controller) => _mapController = controller,
                //     initialCameraPosition: CameraPosition(
                //       target: _initialPosition,
                //       zoom: 11.0,
                //     ),
                //     onTap: _onMapTap, // Detect map clicks
                //     markers: {
                //       Marker(
                //         markerId: MarkerId("selectedLocation"),
                //         position: _currentPosition,
                //       ),
                //     },
                //     myLocationEnabled: false,
                //     myLocationButtonEnabled: false,
                //     gestureRecognizers: Set()
                //       ..add(
                //         Factory<OneSequenceGestureRecognizer>(
                //           () => EagerGestureRecognizer(),
                //         ),
                //       ),
                //     // Custom button instead
                //   ),
                // ),

                SubHeadingWidget(
                  title:
                      "Note: Service available only in Thuvarankurichi, Trichy.",
                  color: const Color.fromARGB(255, 78, 78, 78),
                  fontSize: 15.0,
                ),

                SizedBox(height: 25),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        // _getCurrentPosition();
                      });
                    },
                    child: OutlineBtnWidget(
                      borderColor: AppColors.red,
                      titleColor: AppColors.red,
                      icon: Icons.my_location,
                      iconColor: AppColors.red,
                      title: "Locate me automatically",
                      height: 50,
                      onTap: () {
                        setState(() {
                          _getCurrentLocation();
                        });
                      },
                    )),

                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: AppColors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or',
                        style: TextStyle(color: AppColors.black, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                HeadingWidget(
                  title: "Fill Your Address Manually",
                ),
                SizedBox(height: 16),
                // Row of buttons to select address type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAddressTypeButton('Home', AppAssets.home_red),
                    _buildAddressTypeButton('Work', AppAssets.work_red),
                    _buildAddressTypeButton(
                        'Other', Icons.location_on_outlined),
                  ],
                ),
                SizedBox(height: 20),

                _buildAddressForm(_selectedAddressType),
                SizedBox(height: 20),
              ],
            ),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonWidget(
              borderRadius: 10,
              title: widget.addressId == null ? "Save" : "Update",
              width: screenWidth,
              color: AppColors.red,
              onTap: () {
                // "latitude": widget.lat,
                // "longitude": widget.long,

                if (address1Controller.text.toString() == '' ||
                    address2Controller.text.toString() == '' ||
                    selectedstate == '' ||
                    postController.text.toString() == '' ||
                    lankmarkController.text.toString() == '' ||
                    selectedmainlocationId == '' ||
                    selectedmainlocationId == null ||
                    selectedmainlocationId == "null" ||
                    selectedsublocationId == '' ||
                    selectedsublocationId == null ||
                    selectedsublocationId == "null") {
                  showInSnackBar(context, "Please , Enter the All Fields");
                } else if (address1Controller.text.toString() == '' ||
                    address2Controller.text.toString() == '' ||
                    selectedstate == '') {
                  showInSnackBar(context, "Please , Enter the All Fields");
                } else {
                  widget.addressId == null ? saveaddress() : updateaddress();
                }
              },
            ),
            SizedBox(height: 20),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', ModalRoute.withName('/home'));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MapScreen(),
                        //   ),
                        // );
                      });
                    },
                    child: HeadingWidget(
                      title: 'Skip now',
                    )),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

  // Method to create a button for address type
  Widget _buildAddressTypeButton(String type, dynamic icon) {
    bool isSelected = _selectedAddressType == type;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedAddressType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : AppColors.red,
        backgroundColor: isSelected ? AppColors.red : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.red),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon is IconData
              ? Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.red,
                )
              : Image.asset(
                  isSelected ? AppAssets.home_white : icon,
                  width: 18,
                  height: 18,
                ),
          SizedBox(width: 8),
          Text(type),
        ],
      ),
    );
  }
}

// before add main location dropdown

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:namfood/constants/app_assets.dart';
// import 'package:namfood/pages/HomeScreen/home_screen.dart';
// import 'package:namfood/pages/address/address_list_model.dart';
// import 'package:namfood/pages/maincontainer.dart';
// import 'package:namfood/widgets/heading_widget.dart';
// import 'package:namfood/widgets/outline_btn_widget.dart';
// import '../../constants/app_colors.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import '../../widgets/button_widget.dart';
// import '../../widgets/custom_autocomplete_widget.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/sub_heading_widget.dart';
// import 'addaddress_model.dart';
// import 'address_edit_model.dart';
// import 'address_update_model.dart';
// import 'addresspage.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// import 'get_latlog_address.dart';

// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:intl/intl.dart';
// // import 'package:permission_handler/permission_handler.dart';

// class FillyourAddresspage extends StatefulWidget {
//   int? addressId;
//   FillyourAddresspage({super.key, this.addressId});

//   @override
//   State<FillyourAddresspage> createState() => _FillyourAddresspageState();
// }

// class _FillyourAddresspageState extends State<FillyourAddresspage> {
//   final NamFoodApiService apiService = NamFoodApiService();
//   final GlobalKey<FormState> addressForm = GlobalKey<FormState>();

//   int? _selectedCheckboxIndex;
//   int _selectedIndex = 0;
//   int? _selectedDefaultIndex;

//   String _selectedAddressType = 'Home';

//   TextEditingController contactnoController = TextEditingController();
//   TextEditingController lankmarkController = TextEditingController();
//   TextEditingController address1Controller = TextEditingController();
//   TextEditingController address2Controller = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController postController = TextEditingController();

//   final Map<String, bool> _defaultStatus = {
//     'Home': false,
//     'Work': false,
//     'Other': false,
//   };

//   var selectedstateArr;
//   String? selectedstate;
//   List referList = [
//     {"name": "Tamil Nadu", "value": 1},
//     // {"name": "No", "value": 2},
//   ];
//   var selectedcityArr;
//   String? selectedcity;
//   List refercityList = [
//     {"name": "Trichy", "value": 1},
//     // {"name": "No", "value": 2},
//   ];

//   // Method to build address form
//   Widget _buildAddressForm(String type) {
//     List<Widget> fields = [
//       // CustomeTextField(

//       //   borderColor: AppColors.grey1,
//       //   labelText: 'Contact Number',
//       //   width: MediaQuery.of(context).size.width,
//       // ),
//       CustomeTextField(
//         control: address1Controller,
//         borderColor: AppColors.grey1,
//         labelText: 'Address 1',
//         width: MediaQuery.of(context).size.width,
//       ),
//       CustomeTextField(
//         control: address2Controller,
//         borderColor: AppColors.grey1,
//         labelText: 'Address 2',
//         width: MediaQuery.of(context).size.width,
//       ),
//       CustomeTextField(
//         control: lankmarkController,
//         borderColor: AppColors.grey1,
//         labelText: 'Land Mark',
//         width: MediaQuery.of(context).size.width,
//       ),

//       // CustomeTextField(
//       //   control: cityController,
//       //   borderColor: AppColors.grey1,
//       //   labelText: 'City',
//       //   lines: 1,
//       //   width: MediaQuery.of(context).size.width,
//       // ),
//       CustomAutoCompleteWidget(
//         width: MediaQuery.of(context).size.width / 1.1,
//         selectedItem: selectedcityArr,
//         labelText: 'City',
//         labelField: (item) => item["name"],
//         onChanged: (value) {
//           selectedcity = value["name"];
//           print(selectedcity);
//           // if (selectedyes == 'No') {
//           //   selectedThirdpartyId == 0;
//           //   selectedThirdParty == '';
//           // }
//         },
//         valArr: refercityList,
//       ),
//       // CustomeTextField(
//       //   control: stateController,
//       //   borderColor: AppColors.grey1,
//       //   labelText: 'State',
//       //   lines: 1,
//       //   width: MediaQuery.of(context).size.width,
//       // ),
//       CustomAutoCompleteWidget(
//         width: MediaQuery.of(context).size.width / 1.1,
//         selectedItem: selectedstateArr,
//         labelText: 'State',
//         labelField: (item) => item["name"],
//         onChanged: (value) {
//           selectedstate = value["name"];
//           print(selectedstate);
//           // if (selectedyes == 'No') {
//           //   selectedThirdpartyId == 0;
//           //   selectedThirdParty == '';
//           // }
//         },
//         valArr: referList,
//       ),
//       CustomeTextField(
//         control: postController,
//         borderColor: AppColors.grey1,
//         labelText: 'Post Code',
//         type: const TextInputType.numberWithOptions(),
//         inputFormaters: [
//           FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?\.?\d{0,11}'))
//         ],
//         lines: 1,
//         width: MediaQuery.of(context).size.width,
//       ),
//       Row(
//         children: [
//           Checkbox(
//             side: BorderSide(color: AppColors.grey, width: 2),
//             activeColor: AppColors.red, // Color when checked
//             checkColor: Colors.white, // Tick mark color
//             value: _defaultStatus[type],
//             onChanged: (bool? value) {
//               setState(() {
//                 _defaultStatus[type] = value ?? false; // Update status
//                 print('Default Address for $type: ${_defaultStatus[type]}');
//               });
//             },
//           ),
//           SubHeadingWidget(
//             title: 'Set as default address',
//             color: AppColors.red,
//           )
//         ],
//       ),
//     ];

//     // if (type == 'Other') {
//     //   fields.insert(
//     //     0,
//     //     CustomeTextField(
//     //       borderColor: AppColors.grey1,
//     //       labelText: 'Save As',
//     //       width: MediaQuery.of(context).size.width,
//     //     ),
//     //   );
//     // }

//     return Column(children: fields);
//   }

//   Future saveaddress() async {
//     if (addressForm.currentState!.validate()) {
//       Map<String, dynamic> postData = {
//         "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
//         "type": _selectedAddressType.toString(),
//         "address": address1Controller.text,
//         "address_line_2": address2Controller.text,
//         "city": "Trichy", //selectedcity,
//         "state": selectedstate,
//         "postcode": postController.text,
//         "landmark": lankmarkController.text
//       };
//       print('postData $postData');

//       var result = await apiService.saveaddress(postData);
//       print('result $result');
//       Addaddressmodel response = addaddressmodelFromJson(result);

//       if (response.status.toString() == 'SUCCESS') {
//         // showInSnackBar(context, response.message.toString());

//         // Navigator.pushNamedAndRemoveUntil(
//         //     context, '/home', ModalRoute.withName('/home'));
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MainContainer(initialPage: 2),
//           ),
//         );
//       } else {
//         print(response.message.toString());
//         showInSnackBar(context, response.message.toString());
//       }
//     } else {
//       showInSnackBar(context, "Please fill all fields");
//     }
//   }

//   EditAddressList? addressDetails;

//   Future getAddressById() async {
//     await apiService.getBearerToken();

//     var result = await apiService.getAddressById(widget.addressId);
//     AdddressEditmodel response = adddressEditmodelFromJson(result);
//     print(response);
//     if (response.status.toString() == 'SUCCESS') {
//       setState(() {
//         addressDetails = response.list;
//         _selectedAddressType = (addressDetails!.type ?? '').toString();

//         _defaultStatus[_selectedAddressType] =
//             addressDetails!.defaultAddress == 1;

//         address1Controller.text = addressDetails!.address ?? '';
//         address2Controller.text = addressDetails!.addressLine2 ?? '';
//         cityController.text = addressDetails!.city ?? '';
//         stateController.text = addressDetails!.state ?? '';
//         postController.text = (addressDetails!.postcode ?? '').toString();
//         lankmarkController.text = addressDetails!.landmark ?? '';
//       });
//     } else {
//       showInSnackBar(context, "Data not found");
//       //isLoaded = false;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     refresh();
//     print('AddressById :' + widget.addressId.toString());
//     selectedstateArr =
//         referList.firstWhere((item) => item["name"] == "Tamil Nadu");
//     selectedstate = selectedstateArr["name"];
//     selectedcityArr =
//         refercityList.firstWhere((item) => item["name"] == "Trichy");
//     selectedcity = selectedcityArr["name"];
//   }

//   refresh() async {
//     if (widget.addressId != null) {
//       await getAddressById();
//     }
//   }

//   Future updateaddress() async {
//     await apiService.getBearerToken();
//     if (addressForm.currentState!.validate()) {
//       Map<String, dynamic> postData = {
//         "id": widget.addressId,
//         "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
//         "type": _selectedAddressType.toString(),
//         "address": address1Controller.text,
//         "address_line_2": address2Controller.text,
//         "city": "Trichy",
//         "state": stateController.text,
//         "postcode": postController.text,
//         "landmark": lankmarkController.text
//       };
//       print("updateaddressupdate $postData");
//       var result = await apiService.updateaddress(postData);

//       AdddressUpdatemodel response = adddressUpdatemodelFromJson(result);

//       if (response.status.toString() == 'SUCCESS') {
//         print("test1");
//         // showInSnackBar(context, response.message.toString());
//         //  Navigator.pop(context, {'update': true});
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MainContainer(initialPage: 2),
//           ),
//         );
//       } else {
//         print(response.message.toString());
//         showInSnackBar(context, response.message.toString());
//       }
//     } else {
//       showInSnackBar(context, "Please fill all fields");
//     }
//   }

//   late GoogleMapController _mapController;
//   LatLng _initialPosition =
//       LatLng(37.7749, -122.4194); // Default: San Francisco
//   late LatLng _currentPosition = _initialPosition;
//   String address = "";
//   Future<void> _getCurrentLocation() async {
//     // Check and request permission
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied. Enable them in settings.');
//     }

//     // Get current location
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//       _initialPosition = _currentPosition;

//       _getAddressFromLatLng(position.latitude, position.longitude);
//     });

//     // Move camera to the current position
//     _mapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: _currentPosition, zoom: 14.0),
//       ),
//     );
//   }

//   Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(latitude, longitude);

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         print(place);
//         setState(() {
//           address1Controller.text = (place.name ?? "").toString();
//           address2Controller.text = (place.street ?? "").toString();
//           lankmarkController.text = (place.subLocality ?? "").toString();
//           cityController.text = (place.locality ?? "").toString();
//           stateController.text = (place.administrativeArea ?? "").toString();
//           postController.text = (place.postalCode ?? "").toString();

//           address =
//               "${place.street}, ${place.locality}, ${place.subLocality} ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
//         });
//       }
//     } catch (e) {
//       print("Error getting address: $e");
//     }
//   }

//   void _onMapTap(LatLng position) {
//     setState(() {
//       _currentPosition = position;
//     });
//     _getAddressFromLatLng(position.latitude, position.longitude);
//   }

//   // Future<void> updateaddress() async {
//   //   await apiService.getBearerToken();
//   //   if (addressForm.currentState!.validate()) {
//   //     Map<String, dynamic> postData = {
//   //       "id": widget.addressId,
//   //       "default_address": _defaultStatus[_selectedAddressType]! ? 1 : 0,
//   //       "type": _selectedAddressType.toString(),
//   //       "address": address1Controller.text,
//   //       "address_line_2": address2Controller.text,
//   //       "city": cityController.text,
//   //       "state": stateController.text,
//   //       "postcode": postController.text,
//   //       "landmark": lankmarkController.text,
//   //     };
//   //     print("updateAddress $postData");

//   //     try {
//   //       var result = await apiService.updateaddress(postData);
//   //       AdddressUpdatemodel response = adddressUpdatemodelFromJson(result);

//   //       if (response.status.toString() == 'SUCCESS') {
//   //         if (mounted) {
//   //           // Ensure the widget is still active
//   //           showInSnackBar(context, response.message.toString());

//   //           // Replace Navigator.push with Navigator.pushReplacement for better flow
//   //           Navigator.pushReplacement(
//   //             context,
//   //             MaterialPageRoute(
//   //               builder: (context) => Addresspage(),
//   //             ),
//   //           );
//   //         }
//   //       } else {
//   //         if (mounted) {
//   //           // Ensure the widget is still active
//   //           print(response.message.toString());
//   //           showInSnackBar(context, response.message.toString());
//   //         }
//   //       }
//   //     } catch (e) {
//   //       if (mounted) {
//   //         // Ensure the widget is still active
//   //         showInSnackBar(context, "Error occurred: $e");
//   //       }
//   //       print('Error occurred: $e');
//   //     }
//   //   } else {
//   //     if (mounted) {
//   //       // Ensure the widget is still active
//   //       showInSnackBar(context, "Please fill all fields");
//   //     }
//   //   }
//   // }

//   // String? _currentAddress;
//   // Position? _currentPosition;

//   // Future<PermissionStatus> _handleLocationPermission() async {
//   //   final PermissionStatus status = await Permission.location.request();
//   //   return status;
//   // }

//   // Future<void> _getCurrentPosition() async {
//   //   final PermissionStatus permissionStatus = await _handleLocationPermission();
//   //   // Map<Permission, PermissionStatus> statuses = await [
//   //   //   Permission.location,
//   //   // ].request();
//   //   print("statuses Permission" + permissionStatus.toString());
//   //   if (permissionStatus == PermissionStatus.granted) {
//   //     //final PermissionStatus statuses1 = await _handleLocationPermission1();
//   //     PermissionStatus statuses1 = await Permission.locationAlways.request();
//   //     print("statuses1 Permission" + statuses1.toString());
//   //     if (statuses1 == PermissionStatus.granted) {
//   //       print("statuses2 Permission" + statuses1.toString());
//   //       await Geolocator.getCurrentPosition(
//   //               desiredAccuracy: LocationAccuracy.high)
//   //           .then((Position position) async {
//   //         setState(() => _currentPosition = position);
//   //         _getAddressFromLatLng(_currentPosition!);
//   //         // print('lattitude: ' +
//   //         //     _currentPosition.latitude.toString() +
//   //         //     'Longitude : ' +
//   //         //     _currentPosition.latitude.toString());
//   //         // return position;
//   //       }).catchError((e) {
//   //         debugPrint(e);
//   //       });
//   //     } else {
//   //       showDialog(
//   //           context: context,
//   //           builder: (BuildContext context) {
//   //             return new AlertDialog(
//   //               title: new Text("Alert"),
//   //               content: new Text(
//   //                   "Please Select \"Allow all the time\" to continue..."),
//   //               actions: <Widget>[
//   //                 new ElevatedButton(
//   //                   child: new Text("OK"),
//   //                   onPressed: () async {
//   //                     Navigator.of(context).pop();
//   //                     final PermissionStatus statuses4 =
//   //                         await Permission.locationAlways.request();
//   //                     print("statuses3 Permission" + statuses4.toString());
//   //                   },
//   //                 ),
//   //               ],
//   //             );
//   //           });
//   //     }
//   //   } else {
//   //     print("statuses4 Permission widget");
//   //   }
//   // }

//   // Future<void> _getAddressFromLatLng(Position position) async {
//   //   await placemarkFromCoordinates(position.latitude, position.longitude)
//   //       .then((List<Placemark> placemarks) {
//   //     Placemark place = placemarks[0];
//   //     setState(() {
//   //       _currentAddress =
//   //           '${place.street} ${place.thoroughfare} ${place.subThoroughfare},${place.subLocality},${place.locality},${place.administrativeArea} ${place.subAdministrativeArea},${place.postalCode}, ${place.country}${'(' + place.isoCountryCode! + ')'}';
//   //       print('Address : ' + _currentAddress!);
//   //     });
//   //   }).catchError((e) {
//   //     debugPrint(e);
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.lightGrey3,
//         title: Text('Fill your address'),
//       ),
//       body: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20.0),
//           child: Form(
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             key: addressForm,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //new map
//                 // SizedBox(
//                 //   width: 500.0,
//                 //   height: 500.0,
//                 //   child: GoogleMap(
//                 //     onMapCreated: (controller) => _mapController = controller,
//                 //     initialCameraPosition: CameraPosition(
//                 //       target: _initialPosition,
//                 //       zoom: 11.0,
//                 //     ),
//                 //     onTap: _onMapTap, // Detect map clicks
//                 //     markers: {
//                 //       Marker(
//                 //         markerId: MarkerId("selectedLocation"),
//                 //         position: _currentPosition,
//                 //       ),
//                 //     },
//                 //     myLocationEnabled: false,
//                 //     myLocationButtonEnabled: false,
//                 //     gestureRecognizers: Set()
//                 //       ..add(
//                 //         Factory<OneSequenceGestureRecognizer>(
//                 //           () => EagerGestureRecognizer(),
//                 //         ),
//                 //       ),
//                 //     // Custom button instead
//                 //   ),
//                 // ),

//                 SubHeadingWidget(
//                   title:
//                       "Note: Service available only in Thuvarankurichi, Trichy.",
//                   color: const Color.fromARGB(255, 78, 78, 78),
//                   fontSize: 15.0,
//                 ),

//                 SizedBox(height: 25),
//                 GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         // _getCurrentPosition();
//                       });
//                     },
//                     child: OutlineBtnWidget(
//                       borderColor: AppColors.red,
//                       titleColor: AppColors.red,
//                       icon: Icons.my_location,
//                       iconColor: AppColors.red,
//                       title: "Locate me automatically",
//                       height: 50,
//                       onTap: () {
//                         setState(() {
//                           _getCurrentLocation();
//                         });
//                       },
//                     )),

//                 SizedBox(height: 15),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Divider(
//                         thickness: 1,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         'Or',
//                         style: TextStyle(color: AppColors.black, fontSize: 16),
//                       ),
//                     ),
//                     Expanded(
//                       child: Divider(
//                         thickness: 1,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 HeadingWidget(
//                   title: "Fill Your Address Manually",
//                 ),
//                 SizedBox(height: 16),
//                 // Row of buttons to select address type
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildAddressTypeButton('Home', AppAssets.home_red),
//                     _buildAddressTypeButton('Work', AppAssets.work_red),
//                     _buildAddressTypeButton(
//                         'Other', Icons.location_on_outlined),
//                   ],
//                 ),
//                 SizedBox(height: 20),

//                 _buildAddressForm(_selectedAddressType),
//                 SizedBox(height: 20),
//                 GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         // _getCurrentPosition();
//                       });
//                     },
//                     child: OutlineBtnWidget(
//                       borderColor: AppColors.red,
//                       titleColor: AppColors.red,
//                       icon: Icons.my_location,
//                       iconColor: AppColors.red,
//                       title: "Mark a Place In Map",
//                       height: 50,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MapScreen(),
//                           ),
//                         );
//                       },
//                     )),
//               ],
//             ),
//           )),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ButtonWidget(
//               borderRadius: 10,
//               title: widget.addressId == null ? "Save" : "Update",
//               width: screenWidth,
//               color: AppColors.red,
//               onTap: () {
//                 widget.addressId == null ? saveaddress() : updateaddress();
//               },
//             ),
//             SizedBox(height: 20),
//             Center(
//                 child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, '/home', ModalRoute.withName('/home'));
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => MapScreen(),
//                         //   ),
//                         // );
//                       });
//                     },
//                     child: HeadingWidget(
//                       title: 'Skip now',
//                     )),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                 )
//               ],
//             )),
//           ],
//         ),
//       ),
//     );
//   }

//   // Method to create a button for address type
//   Widget _buildAddressTypeButton(String type, dynamic icon) {
//     bool isSelected = _selectedAddressType == type;
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           _selectedAddressType = type;
//         });
//       },
//       style: ElevatedButton.styleFrom(
//         foregroundColor: isSelected ? Colors.white : AppColors.red,
//         backgroundColor: isSelected ? AppColors.red : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: BorderSide(color: AppColors.red),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           icon is IconData
//               ? Icon(
//                   icon,
//                   color: isSelected ? Colors.white : AppColors.red,
//                 )
//               : Image.asset(
//                   isSelected ? AppAssets.home_white : icon,
//                   width: 18,
//                   height: 18,
//                 ),
//           SizedBox(width: 8),
//           Text(type),
//         ],
//       ),
//     );
//   }
// }
