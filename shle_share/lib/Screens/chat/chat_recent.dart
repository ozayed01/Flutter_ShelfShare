import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/Screens/chat/chat.dart';
import 'package:shle_share/Screens/chat/chat_users.dart';
import 'package:shle_share/models/UserChatInfo.dart';
import 'package:shle_share/widget/user_profile.dart';

class ChatRecentList extends StatefulWidget {
  const ChatRecentList({Key? key}) : super(key: key);

  @override
  State<ChatRecentList> createState() => _ChatRecentListState();
}

class _ChatRecentListState extends State<ChatRecentList> {
  late Stream<QuerySnapshot> usersStream;
  final user = FirebaseAuth.instance.currentUser!;
  final Set<String> displayedChatRooms = Set<String>();

  @override
  void initState() {
    super.initState();
    usersStream = getUsersStream();
  }

  Stream<QuerySnapshot> getUsersStream() {
    return FirebaseFirestore.instance
        .collection('recent_chat')
        .doc(user.uid)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<List<DocumentSnapshot>> filterCurrentUser(
      Stream<QuerySnapshot> usersStream, String currentUserId) {
    return usersStream.map((snapshot) {
      return snapshot.docs.where((doc) => doc.id != currentUserId).toList();
    });
  }

  Future<Map<String, dynamic>> getReceiverInfo(String chatroomId) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final parts = chatroomId.split('_');
    final otherUserId = parts.firstWhere((p) => p != userID);
    final otherUserInfo = await FirebaseFirestore.instance
        .collection('Users')
        .doc(otherUserId)
        .get();

    return otherUserInfo.data() ?? {};
  }

  Future<DocumentSnapshot?> getLastMessage(String chatroomId) async {
    final lastMessage = await FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    return lastMessage.docs.isNotEmpty ? lastMessage.docs.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Chat'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ChatUserList(),
              ));
            },
            icon: const Icon(Icons.outgoing_mail),
          ),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No Recent Messages were found click on '),
                      SizedBox(width: 10),
                      Icon(
                        Icons.outgoing_mail,
                        size: 30,
                      ),
                    ],
                  ),
                  Text('to send a new Message!'),
                ],
              ),
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
              final chatRoomId = loadedUsers[index]['chatromId'] as String;
              if (displayedChatRooms.contains(chatRoomId)) {
                return SizedBox(); // Return an empty widget if already displayed
              } else {
                displayedChatRooms
                    .add(chatRoomId); // Mark the chat room as displayed
              }

              return FutureBuilder<Map<String, dynamic>>(
                future: getReceiverInfo(chatRoomId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text('Something went wrong...'),
                    );
                  }

                  return FutureBuilder<DocumentSnapshot?>(
                    future: getLastMessage(chatRoomId),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return lastMessagesUser(chatromId: chatRoomId);
                    },
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

Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getLastMessage(
    String chatroomId) async {
  final lastMessage = await FirebaseFirestore.instance
      .collection('Chats')
      .doc(chatroomId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .limit(1)
      .get();

  return lastMessage.docs.isNotEmpty ? lastMessage.docs.first : null;
}

class lastMessagesUser extends StatelessWidget {
  const lastMessagesUser({Key? key, required this.chatromId}) : super(key: key);
  final String chatromId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Chats')
          .doc(chatromId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get(),
      builder: (context, chatSnapShot) {
        if (chatSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapShot.hasData || chatSnapShot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found!'),
          );
        }
        if (chatSnapShot.hasError) {
          return const Center(
            child: Text('Something went wrong....'),
          );
        }

        final chatMessages = chatSnapShot.data!.docs;

        return FutureBuilder<Map<String, dynamic>>(
          future: getReceiverInfo(chatromId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text('The User is Deleted'),
              );
            }

            final receiverInfo = snapshot.data!;
            final chatMessage =
                chatMessages.isNotEmpty ? chatMessages.first : null;

            if (chatMessage == null) {
              return const Center(
                child: Text('No messages found!2'),
              );
            }

            final receiverName = receiverInfo['full_name'] as String? ?? '';
            final receiverUsername = receiverInfo['username'] as String? ?? '';
            final receiverUserPicUrl =
                receiverInfo['userPicUrl'] as String? ?? '';
            final receiverBio = receiverInfo['Bio'] as String? ?? '';
            final receiverId = receiverInfo['userId'] as String? ?? '';

            return ListTile(
              title: Text(receiverName),
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                foregroundImage: NetworkImage(receiverUserPicUrl),
              ),
              contentPadding: const EdgeInsets.only(top: 10, right: 10),
              subtitle: Text(chatMessage['text'] as String),
              trailing: Text(
                formatFirestoreTimestampToRegularDate(
                  chatMessage['createdAt'] as Timestamp,
                ),
              ),
              onLongPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserProfile(
                        user: UserChatInfo(
                            username: receiverUsername,
                            name: receiverName,
                            userImgUrl: receiverUserPicUrl,
                            userId: receiverId,
                            userbio: receiverBio))));
              },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      user: UserChatInfo(
                        username: receiverUsername,
                        name: receiverName,
                        userImgUrl: receiverUserPicUrl,
                        userId: receiverInfo['userId'] as String? ?? '',
                        userbio: '',
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>> getReceiverInfo(String chatromId) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    var otherUserId = '';
    List<String> parts = chatromId.split('_');
    for (var p in parts) {
      if (p != userID) {
        otherUserId = p;
      }
    }

    final receiverInfo = await FirebaseFirestore.instance
        .collection('Users')
        .doc(otherUserId)
        .get();

    return receiverInfo.data()!;
  }

  String formatFirestoreTimestampToRegularDate(Timestamp firestoreTimestamp) {
    DateTime dateTime = firestoreTimestamp.toDate();
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 3) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
