import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/Screens/chat/chat_messages.dart';
import 'package:shle_share/Screens/chat/new_message.dart';
import 'package:shle_share/models/UserChatInfo.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

  final UserChatInfo user;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String generateChatRoomId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final CurrUser = FirebaseAuth.instance.currentUser!;
    final user = widget.user;
    final String ChatRoomId = generateChatRoomId(user.userId, CurrUser.uid);
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: Column(
          children: [
            Expanded(
                child: ChatMessages(
              ChatRoomId: ChatRoomId,
            )),
            NewMessage(ChatRoomId: ChatRoomId),
          ],
        ));
  }
}
