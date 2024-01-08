import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/Screens/chat/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.ChatRoomId});
  final String ChatRoomId;
  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Chats')
          .doc(ChatRoomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapShot) {
        if (chatSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapShot.hasData || chatSnapShot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No meesages found!'),
          );
        }
        if (chatSnapShot.hasError) {
          const Center(
            child: Text('Somthing went wrong....'),
          );
        }
        final loadedM = chatSnapShot.data!.docs;
        return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: loadedM.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedM[index].data();
              final nextChatMessage = (index + 1 < loadedM.length)
                  ? loadedM[index + 1].data()
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;

              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authUser.uid == currentMessageUserId);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage['userPicUrl'],
                    username: chatMessage['name'],
                    message: chatMessage['text'],
                    isMe: authUser.uid == currentMessageUserId);
              }
            });
      },
    );
  }
}
