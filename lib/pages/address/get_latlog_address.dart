import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants/app_colors.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _selectedPosition = LatLng(10.3788, 78.3877);
  LatLng _currentPosition = LatLng(10.3788, 78.3877);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapTapped(LatLng tappedPosition) {
    setState(() {
      _selectedPosition = tappedPosition;
    });
  }

  void _showBottomModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.red,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  HeadingWidget(
                    title: 'Bengaluru',
                    fontSize: 22.00,
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              SubHeadingWidget(
                title:
                    'No 37 Paranjothi Nagar Thalakoidi, velour Nagar Bengaluru-620005, Landmark-Andavan collage',
                fontSize: 20.00,
              ),
              SizedBox(
                height: 18,
              ),
              ButtonWidget(
                title: 'Confirm location',
                width: double.infinity,
                height: 50,
                color: AppColors.red,
                borderRadius: 10,
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeoLocator Map Demo'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 13.0,
          onTap: (tapPosition, latLng) {
            _onMapTapped(latLng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedPosition,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              Marker(
                point: _currentPosition,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Selected Location: Lat: ${_selectedPosition.latitude}, Long: ${_selectedPosition.longitude}\n'
          'Current Location: Lat: ${_currentPosition.latitude}, Long: ${_currentPosition.longitude}',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
