import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/Screens/chat/chat_messages.dart';
import 'package:shle_share/Screens/chat/new_message.dart';
import 'package:shle_share/models/UserChatInfo.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.useId, this.text})
      : super(key: key);

  final String useId;
  final String? text;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Future<UserChatInfo> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUser(widget.useId);
  }

  String generateChatRoomId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

  Future<UserChatInfo> getUser(String userId) async {
    final userInfo =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return UserChatInfo(
      username: userInfo.get('username'),
      name: userInfo.get('full_name'),
      userImgUrl: userInfo.get('userPicUrl'),
      userId: userId,
      userbio: userInfo.get('Bio'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CurrUser = FirebaseAuth.instance.currentUser!;
    return FutureBuilder<UserChatInfo>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text('Something went wrong!')));
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('User not found!')));
        }
        final user = snapshot.data!;
        final String chatRoomId = generateChatRoomId(user.userId, CurrUser.uid);
        return Scaffold(
          appBar: AppBar(
            title: Text(user.name),
          ),
          body: Column(
            children: [
              Expanded(
                child: ChatMessages(
                  ChatRoomId: chatRoomId,
                ),
              ),
              NewMessage(ChatRoomId: chatRoomId, initialText: widget.text),
            ],
          ),
        );
      },
    );
  }
}
