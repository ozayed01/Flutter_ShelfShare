import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shle_share/models/UserChatInfo.dart';
import 'package:shle_share/models/request.dart';
import 'package:shle_share/widget/add_requst.dart';
import 'package:shle_share/widget/request_view.dart';

class RequestFeedScreen extends StatefulWidget {
  const RequestFeedScreen({Key? key}) : super(key: key);

  @override
  State<RequestFeedScreen> createState() => _RequestFeedScreenState();
}

class _RequestFeedScreenState extends State<RequestFeedScreen> {
  late Stream<QuerySnapshot> usersStream;
  bool isLoading = true;
  double? currentLng;
  double? currentLat;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    usersStream = getUsersStream();
  }

  void _getCurrentLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      PermissionStatus permissionGranted = await location.hasPermission();

      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      LocationData locationData = await location.getLocation();
      setState(() {
        isLoading = false;
        currentLat = locationData.latitude;
        currentLng = locationData.longitude;
      });
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    final user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('Requests_feed')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<List<DocumentSnapshot>> filterCurrentUser(
      Stream<QuerySnapshot> usersStream, String currentUserId) {
    return usersStream.map((snapshot) {
      return snapshot.docs.where((doc) => doc.id != currentUserId).toList();
    });
  }

  void _openAddRequestOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => (AddRequest()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Feed'),
        actions: [
          IconButton(
              onPressed: _openAddRequestOverlay,
              icon: const Icon(Icons.add_box_rounded))
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: filterCurrentUser(usersStream, authUser.uid),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Requests were found!'),
            );
          }
          if (userSnapshot.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }

          final loadedUsers = userSnapshot.data!;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(left: 0, top: 10),
            itemCount: loadedUsers.length,
            itemBuilder: (context, index) {
              final user = loadedUsers[index].data() as Map<String, dynamic>;

              return RequestView(
                  request: Request(
                bookimgUrl: user['book_image'],
                bookDtails: [
                  user['book_name'],
                  user['book_auther'],
                  user['relase_date']
                ],
                user: UserChatInfo(
                    username: user['username'],
                    name: user['full_name'],
                    userImgUrl: user['userPicUrl'],
                    userId: user['userId'],
                    userbio: user['Bio']),
                exhangeText: user['request_text'],
                createdAt: user['createdAt'],
                requestLat: user['userLat'],
                requestLng: user['userLng'],
                userLat: currentLat!,
                userLng: currentLng!,
              ));
            },
          );
        },
      ),
    );
  }
}
