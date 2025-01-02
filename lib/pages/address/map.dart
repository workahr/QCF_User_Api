import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/nam_food_api_service.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import 'address_edit_model.dart';
import 'fillyour_addresspage.dart';

class Mappage extends StatefulWidget {
  int? addressId;

  Mappage({
    super.key,
    this.addressId,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<Mappage> {
  final NamFoodApiService apiService = NamFoodApiService();

  TextEditingController contactnoController = TextEditingController();
  TextEditingController lankmarkController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController logController = TextEditingController();

  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(10.7905, 78.7047); // Default position
  late LatLng _currentPosition = _initialPosition;
  String address = "";

  Set<Marker> _markers = {};

  bool _isLoading = true;
  bool isMapControllerInitialized = false;

  // Future<void> _getCurrentLocation() async {
  //   try {
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
  //       _isLoading = false; // Stop loading after location fetch
  //       _getAddressFromLatLng(position.latitude, position.longitude);
  //     });

  //     // Move camera to the current position
  //     _mapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(target: _currentPosition, zoom: 14.0),
  //       ),
  //     );
  //   } catch (e) {
  //     print("Error fetching location: $e");
  //     setState(() {
  //       _isLoading = false; // Stop loading on error
  //     });
  //   }
  // }

  // Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(latitude, longitude);

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       setState(() {
  //         address1Controller.text = (place.name ?? "").toString();
  //         address2Controller.text = (place.street ?? "").toString();
  //         lankmarkController.text = (place.subLocality ?? "").toString();
  //         cityController.text = (place.locality ?? "").toString();
  //         stateController.text = (place.administrativeArea ?? "").toString();
  //         postController.text = (place.postalCode ?? "").toString();
  //         latController.text = latitude.toString();
  //         logController.text = longitude.toString();
  //         address =
  //             "${place.street}, ${place.locality}, ${place.subLocality} ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
  //       });
  //       _showBottomModal();
  //     }
  //   } catch (e) {
  //     print("Error getting address: $e");
  //   }
  // }

  // void _onMapTap(LatLng position) {
  //   setState(() {
  //     _currentPosition = position;

  //     // Clear existing markers and add the new marker
  //     _markers.clear();
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId("selectedLocation"),
  //         position: position,
  //       ),
  //     );
  //   });

  //   // Fetch address for the new location
  //   _getAddressFromLatLng(position.latitude, position.longitude);

  //   // Move the camera to the new position
  //   _mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: position, zoom: 14.0),
  //     ),
  //   );
  // }

  void _showBottomModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.red,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  HeadingWidget(
                    title: 'Selected Location',
                    fontSize: 22.0,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SubHeadingWidget(
                title: address,
                fontSize: 20.0,
              ),
              if (latController.text.isNotEmpty &&
                  logController.text.isNotEmpty) ...[
                SizedBox(height: 6),
                SubHeadingWidget(
                  title:
                      "Lat: ${latController.text}, Long: ${logController.text}",
                  fontSize: 18.0,
                ),
              ],
              const SizedBox(height: 12),
              ButtonWidget(
                title: 'Confirm location',
                width: double.infinity,
                height: 50.0,
                color: AppColors.red,
                borderRadius: 10,
                onTap: () {
                  if (widget.addressId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FillyourAddresspage(
                          lat: latController.text,
                          long: logController.text,
                          address1: address1Controller.text,
                          address2: address2Controller.text,
                          landmark: lankmarkController.text,
                          city: cityController.text,
                          postcode: postController.text,
                          addressId: widget.addressId,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FillyourAddresspage(
                          lat: latController.text,
                          long: logController.text,
                          address1: address1Controller.text,
                          address2: address2Controller.text,
                          landmark: lankmarkController.text,
                          city: cityController.text,
                          postcode: postController.text,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  EditAddressList? addressDetails;

  Future<void> _getCurrentLocation() async {
    try {
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

      // setState(() {
      //   _currentPosition = LatLng(position.latitude, position.longitude);
      //   _initialPosition = _currentPosition;
      //   _isLoading = false; // Stop loading after location fetch
      //   _getAddressFromLatLng(position.latitude, position.longitude);
      // });

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _initialPosition = _currentPosition;
        _isLoading = false; // Stop loading after location fetch
        latController.text =
            position.latitude.toString(); // Update lat controller
        logController.text =
            position.longitude.toString(); // Update long controller
        _getAddressFromLatLng(position.latitude, position.longitude);
      });

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 14.0),
        ),
      );
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  Future getAddressById() async {
    try {
      await apiService.getBearerToken();

      var result = await apiService.getAddressById(widget.addressId);
      AdddressEditmodel response = adddressEditmodelFromJson(result);

      if (response.status.toString() == 'SUCCESS') {
        setState(() {
          addressDetails = response.list;

          double latitude =
              double.tryParse(addressDetails!.latitude ?? '0') ?? 0;
          double longitude =
              double.tryParse(addressDetails!.longitude ?? '0') ?? 0;

          latController.text = addressDetails!.latitude ?? '';
          logController.text = addressDetails!.longitude ?? '';

          _currentPosition = LatLng(latitude, longitude);
          _initialPosition = _currentPosition;

          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('addressLocation'),
              position: _currentPosition,
            ),
          );

          if (isMapControllerInitialized) {
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: _currentPosition, zoom: 14.0),
              ),
            );
          }

          // Fetch address details from latitude and longitude
          _getAddressFromLatLng(latitude, longitude);
        });

        // Ensure the modal only shows once after the data is loaded
        if (!_modalShown) {
          // Delay modal display until address data is fully loaded
          Future.delayed(Duration(milliseconds: 500), () {
            if (!_modalShown) {
              _showBottomModal();
              setState(() {
                _modalShown =
                    true; // Set the flag to prevent showing the modal again
              });
            }
          });
        }

        _isLoading = false;
      } else {
        showInSnackBar(context, "Data not found");
        setState(() {
          _isLoading = false; // Stop loading if no data is found
        });
      }
    } catch (e) {
      print("Error fetching address by ID: $e");
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _currentPosition = position;

      // Clear existing markers and add the new marker
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("selectedLocation"),
          position: position,
        ),
      );
      // Update lat and long controllers
      latController.text = position.latitude.toString();
      logController.text = position.longitude.toString();
    });

    // Fetch address for the new location
    _getAddressFromLatLng(position.latitude, position.longitude);

    // Move the camera to the new position
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14.0),
      ),
    );

    // Reset modal flag to show the modal again for the new marker
    _modalShown =
        false; // Reset the flag so modal will show after a new marker is placed
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          address1Controller.text = place.name ?? "";
          address2Controller.text = place.subLocality ?? "";
          lankmarkController.text = place.subLocality ?? "";
          // cityController.text = place.locality ?? "";
          //stateController.text = place.administrativeArea ?? "";
          postController.text = place.postalCode ?? "";
          address =
              "${place.street}, ${place.locality}, ${place.subLocality} ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        });

        // Trigger the modal after updating the address if not already shown
        if (!_modalShown) {
          _showBottomModal();
          setState(() {
            _modalShown =
                true; // Set the flag to prevent showing the modal again
          });
        }
      } else {
        print("No placemarks found for the provided coordinates.");
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.addressId != null) {
      getAddressById();
    } else {
      _getCurrentLocation();
    }
  }

  bool _modalShown = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                      isMapControllerInitialized = true;
                      if (widget.addressId != null) {
                        getAddressById();
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 11.0,
                    ),
                    onTap: _onMapTap,
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    gestureRecognizers: Set()
                      ..add(
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      ),
                  ),
                ),
              ],
            ),
    );
  }
}













// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../constants/app_colors.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import '../../widgets/button_widget.dart';
// import '../../widgets/heading_widget.dart';
// import '../../widgets/sub_heading_widget.dart';
// import 'address_edit_model.dart';
// import 'fillyour_addresspage.dart';

// class Mappage extends StatefulWidget {
//   int? addressId;

//   Mappage({
//     super.key,
//     this.addressId,
//   });
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<Mappage> {
//   final NamFoodApiService apiService = NamFoodApiService();

//   TextEditingController contactnoController = TextEditingController();
//   TextEditingController lankmarkController = TextEditingController();
//   TextEditingController address1Controller = TextEditingController();
//   TextEditingController address2Controller = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController postController = TextEditingController();
//   TextEditingController latController = TextEditingController();
//   TextEditingController logController = TextEditingController();

//   late GoogleMapController _mapController;
//   LatLng _initialPosition = LatLng(10.7905, 78.7047); // Default position
//   late LatLng _currentPosition = _initialPosition;
//   String address = "";

//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         await Geolocator.openLocationSettings();
//         return Future.error('Location services are disabled.');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return Future.error('Location permissions are denied.');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         return Future.error(
//             'Location permissions are permanently denied. Enable them in settings.');
//       }

//       // Get current location
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _initialPosition = _currentPosition;
//         _isLoading = false;
//         _getAddressFromLatLng(position.latitude, position.longitude);
//       });

//       // Move camera to the current position
//       _mapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: _currentPosition, zoom: 14.0),
//         ),
//       );
//     } catch (e) {
//       print("Error fetching location: $e");
//       setState(() {
//         _isLoading = false; // Stop loading even if there’s an error
//       });
//     }
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
//           latController.text = latitude.toString();
//           logController.text = longitude.toString();
//           print("lat : $latitude");
//           address =
//               "${place.street}, ${place.locality}, ${place.subLocality} ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
//         });
//         _showBottomModal();
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

//   void _showBottomModal() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(14.0), // Adjust padding if needed
//           child: Column(
//             mainAxisSize:
//                 MainAxisSize.min, // Ensures the modal size fits its content
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.location_on_outlined,
//                     color: AppColors.red,
//                     size: 30,
//                   ),
//                   const SizedBox(width: 10), // Adjust width if needed
//                   HeadingWidget(
//                     title: 'Selected Location',
//                     fontSize: 22.0,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8), // Reduced height
//               SubHeadingWidget(
//                 title: address,
//                 fontSize: 20.0,
//               ),
//               if (latController.text.isNotEmpty &&
//                   logController.text.isNotEmpty) ...[
//                 SizedBox(height: 6), // Reduced height
//                 SubHeadingWidget(
//                   title:
//                       "Lat: ${latController.text}, Long: ${logController.text}",
//                   fontSize: 18.0, // Optional font size adjustment
//                 ),
//               ],
//               const SizedBox(height: 12), // Reduced height before the button
//               ButtonWidget(
//                 title: 'Confirm location',
//                 width: double.infinity,
//                 height: 50.0,
//                 color: AppColors.red,
//                 borderRadius: 10,
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FillyourAddresspage(
//                         lat: latController.text,
//                         long: logController.text,
//                         address1: address1Controller.text,
//                         address2: address2Controller.text,
//                         landmark: lankmarkController.text,
//                         city: cityController.text,
//                         postcode: postController.text,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Set<Marker> _markers = {};

//   EditAddressList? addressDetails;

//   Future<void> getAddressById() async {
//     try {
//       await apiService.getBearerToken();

//       var result = await apiService.getAddressById(widget.addressId);
//       AdddressEditmodel response = adddressEditmodelFromJson(result);

//       if (response.status.toString() == 'SUCCESS' && response.list != null) {
//         setState(() {
//           addressDetails = response.list;

//           double latitude =
//               double.tryParse(addressDetails!.latitude ?? '0') ?? 0;
//           double longitude =
//               double.tryParse(addressDetails!.longitude ?? '0') ?? 0;

//           // Update controllers
//           latController.text = addressDetails!.latitude ?? '';
//           logController.text = addressDetails!.longitude ?? '';

//           // Update map position and marker
//           _currentPosition = LatLng(latitude, longitude);
//           _initialPosition = _currentPosition;

//           _markers.clear(); // Clear any existing markers
//           _markers.add(
//             Marker(
//               markerId: MarkerId('addressLocation'),
//               position: _currentPosition,
//             ),
//           );

//           // Ensure map controller is ready before moving the camera
//           if (isMapControllerInitialized) {
//             _mapController.animateCamera(
//               CameraUpdate.newCameraPosition(
//                 CameraPosition(target: _currentPosition, zoom: 14.0),
//               ),
//             );
//           }

//           _isLoading = false; // Stop the loading animation
//         });
//       } else {
//         setState(() {
//           _isLoading =
//               false; // Stop the loading animation even if data is not found
//         });
//         showInSnackBar(context, "Data not found");
//       }
//     } catch (e) {
//       print("Error fetching address by ID: $e");
//       setState(() {
//         _isLoading = false; // Stop the loading animation on error
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.addressId != null) {
//       // Start loading and fetch address by ID
//       _isLoading = true;
//       getAddressById();
//     } else {
//       // Start loading and fetch current location
//       _isLoading = true;
//       _getCurrentLocation();
//     }
//   }

//   bool _isLoading = true;
//   bool isMapControllerInitialized = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Google Maps Example")),
//       body: _isLoading
//           ? Shimmer.fromColors(
//               baseColor: Colors.grey[300]!,
//               highlightColor: Colors.grey[100]!,
//               child: Container(
//                 color: Colors.grey,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: GoogleMap(
//                     // onMapCreated: (controller) => _mapController = controller,
//                     onMapCreated: (controller) {
//                       _mapController = controller;
//                       isMapControllerInitialized = true; // Set the flag
//                       if (widget.addressId != null) {
//                         getAddressById(); // Fetch the address only after the map controller is ready
//                       }
//                     },
//                     initialCameraPosition: CameraPosition(
//                       target: _initialPosition,
//                       zoom: 11.0,
//                     ),
//                     onTap: _onMapTap, // Detect map clicks
//                     markers: _markers,
//                     // markers: {
//                     //   Marker(
//                     //     markerId: MarkerId("selectedLocation"),
//                     //     position: _currentPosition,
//                     //   ),
//                     // },
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     gestureRecognizers: Set()
//                       ..add(
//                         Factory<OneSequenceGestureRecognizer>(
//                           () => EagerGestureRecognizer(),
//                         ),
//                       ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }