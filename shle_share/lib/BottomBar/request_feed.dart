import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/models/UserChatInfo.dart';
import 'package:shle_share/widget/add_requst.dart';
import 'package:shle_share/widget/post.dart';

class RequestFeedScreen extends StatefulWidget {
  const RequestFeedScreen({Key? key}) : super(key: key);

  @override
  State<RequestFeedScreen> createState() => _RequestFeedScreenState();
}

class _RequestFeedScreenState extends State<RequestFeedScreen> {
  late Stream<QuerySnapshot> usersStream;

  @override
  void initState() {
    super.initState();
    usersStream = getUsersStream();
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

          return ListView.builder(
            padding: EdgeInsets.only(left: 0, top: 10),
            itemCount: loadedUsers.length,
            itemBuilder: (context, index) {
              final user = loadedUsers[index].data() as Map<String, dynamic>;
              return Post(
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
                  Date: '2011');
            },
          );
        },
      ),
    );
  }
}
