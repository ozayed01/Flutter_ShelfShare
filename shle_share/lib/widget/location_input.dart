import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shle_share/models/UserChatInfo.dart';
import 'package:shle_share/widget/map_pick.dart';

class LocationInput extends StatefulWidget {
  LocationInput({super.key, required this.onSelectedLocation});
  final void Function(PlaceLocation location) onSelectedLocation;
  @override
  State<LocationInput> createState() {
    return _locationInputState();
  }
}

class _locationInputState extends State<LocationInput> {
  var _isLoading = false;
  PlaceLocation? _pickedLocation;

  String get locationSnapShot {
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=${dotenv.env['google_maps_APIKEY']}";
  }

  void _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&location_type=ROOFTOP&result_type=street_address&key=${dotenv.env['google_maps_APIKEY']}');
    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final address = resdata['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
      _isLoading = false;
    });
    widget.onSelectedLocation(_pickedLocation!);
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
    setState(() {
      _isLoading = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedlocatin = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
    if (pickedlocatin == null) {
      return;
    }
    print('pickedlocatin.latitude: ${pickedlocatin.latitude}');
    _savePlace(pickedlocatin.latitude, pickedlocatin.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No Location is Picked',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (_pickedLocation != null) {
      content = Image.network(
        locationSnapShot,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isLoading) {
      content = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 1,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            child: content),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              label: Text(
                'Get Current Location',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map,
                  color: Theme.of(context).colorScheme.onBackground),
              label: Text(
                'Select on map',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            )
          ],
        )
      ],
    );
  }
}
