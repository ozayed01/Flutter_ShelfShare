import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatInfo {
  const UserChatInfo({
    required this.username,
    required this.name,
    required this.userImgUrl,
    required this.userId,
    required this.userbio,
    // required this.location,
  });

  final String name;
  final String username;
  final String userImgUrl;
  final String userId;
  final String userbio;
  // final PlaceLocation location;
}

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
  final double latitude;
  final double longitude;
  final String address;
}
