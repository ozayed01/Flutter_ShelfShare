import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  var isLoading = true;
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  double? currentLat;
  double? currentLng;
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    setState(() {
      currentLat = lat;
      currentLng = lng;
      isLoading = false;
    });
    print(currentLat);
    print(currentLng);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = (isLoading)
        ? CircularProgressIndicator()
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLat!,
                currentLng!,
              ),
              zoom: 13,
            ),
            markers: {
                Marker(
                    markerId: MarkerId('Book1'),
                    position: LatLng(
                      currentLat!,
                      currentLng!,
                    ),
                    infoWindow: const InfoWindow(
                      title: "Book 1",
                    ))
              });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: Center(child: content),
    );
  }
}
