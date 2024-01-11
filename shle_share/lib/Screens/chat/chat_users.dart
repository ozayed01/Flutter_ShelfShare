import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/Screens/chat/chat.dart';

class ChatUserList extends StatefulWidget {
  const ChatUserList({Key? key}) : super(key: key);

  @override
  State<ChatUserList> createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {
  late Stream<QuerySnapshot> usersStream;

  @override
  void initState() {
    super.initState();
    usersStream = getUsersStream();
  }

  Stream<QuerySnapshot> getUsersStream() {
    return FirebaseFirestore.instance
        .collection('Users')
        .orderBy('userId', descending: false)
        .snapshots();
  }

  Stream<List<DocumentSnapshot>> filterCurrentUser(
      Stream<QuerySnapshot> usersStream, String currentUserId) {
    return usersStream.map((snapshot) {
      return snapshot.docs.where((doc) => doc.id != currentUserId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Chat'),
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
              child: Text('No Useres were found!'),
            );
          }
          if (userSnapshot.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }

          final loadedUsers = userSnapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(left: 0, top: 10),
            itemCount: loadedUsers.length,
            itemBuilder: (context, index) {
              final user = loadedUsers[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(user['full_name'] as String),
                leading: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  foregroundImage: NetworkImage(user['userPicUrl'] as String),
                ),
                contentPadding: const EdgeInsets.only(top: 10, right: 10),
                subtitle: Text('@${user['username']}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        useId: user['userId'] as String,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
