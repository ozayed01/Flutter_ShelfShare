import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shle_share/models/UserChatInfo.dart';

class Request {
  const Request({
    required this.bookimgUrl,
    required this.bookDtails,
    required this.user,
    required this.exhangeText,
    required this.createdAt,
    required this.userLat,
    required this.userLng,
    required this.requestLat,
    required this.requestLng,
  });

  final String bookimgUrl;
  final List<String> bookDtails;
  final UserChatInfo user;

  final String exhangeText;

  final double userLat;
  final double userLng;
  final double requestLat;
  final double requestLng;

  final Timestamp createdAt;
}
