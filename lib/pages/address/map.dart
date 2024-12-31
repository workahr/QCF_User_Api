import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Mappage extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<Mappage> {
  late GoogleMapController _mapController;
  LatLng _initialPosition =
      LatLng(37.7749, -122.4194); // Default: San Francisco
  late LatLng _currentPosition = _initialPosition;
  String address = "";

  // Text controllers for address fields
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController logController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check and request location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
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

      // Safely move the camera
      if (_mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition, zoom: 14.0),
          ),
        );
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        setState(() {
          address1Controller.text = place.name ?? "";
          address2Controller.text = place.street ?? "";
          landmarkController.text = place.subLocality ?? "";
          cityController.text = place.locality ?? "";
          stateController.text = place.administrativeArea ?? "";
          postController.text = place.postalCode ?? "";
          latController.text = latitude.toString();
          logController.text = longitude.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps Example")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 11.0,
              ),
              onTap: _onMapTap,
              markers: {
                Marker(
                  markerId: MarkerId("selectedLocation"),
                  position: _currentPosition,
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Selected Address: $address"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    postController.dispose();
    latController.dispose();
    logController.dispose();
    super.dispose();
  }
}
