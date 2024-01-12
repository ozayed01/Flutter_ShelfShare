import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  var isLoading = true;
  double? currentLat;
  double? currentLng;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchRequests();
  }

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
  }

  Future<BitmapDescriptor> getCustomMarker(String imageUrl) async {
    final Uint8List markerImageBytes = await _getBytesFromUrl(imageUrl);
    return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  Future<Uint8List> _getBytesFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;

    final ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: 120);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _fetchRequests() async {
    FirebaseFirestore.instance
        .collection('Requests_feed')
        .get()
        .then((querySnapshot) async {
      for (var document in querySnapshot.docs) {
        double lat = document.data()['userLat'];
        double lng = document.data()['userLng'];
        String bookImageUrl = document.data()['book_image'];

        BitmapDescriptor customIcon = await getCustomMarker(bookImageUrl);

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(document.id),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                onTap: () {
                 
                },
                title: document.data()['book_name'],
                // ignore: prefer_interpolation_to_compose_strings
                snippet: "${"@" + document.data()['username']}  " +
                    document.data()['book_auther'],
              ),
              icon: customIcon,
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = (isLoading)
        ? CircularProgressIndicator()
        : GoogleMap(
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLat ?? 0.0,
                currentLng ?? 0.0,
              ),
              zoom: 13,
            ),
            markers: _markers,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: Center(child: content),
    );
  }
}
