import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key, required this.ChatRoomId, this.initialText})
      : super(key: key);
  final String ChatRoomId;
  final String? initialText;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _messageController.text = widget.initialText!;
      print('initState: Setting initial text: ${widget.initialText}');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();
    final otherUserId = getOtherUserId(widget.ChatRoomId);
    final user = FirebaseAuth.instance.currentUser!;
    final userInfo = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.ChatRoomId)
        .collection('messages')
        .add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userInfo.data()!['username'],
      'name': userInfo.data()!['full_name'],
      'userPicUrl': userInfo.data()!['userPicUrl'],
    });
    FirebaseFirestore.instance
        .collection('recent_chat')
        .doc(user.uid)
        .collection('messages')
        .add({
      'chatromId': widget.ChatRoomId,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'text': enteredMessage,
      'name': userInfo.data()!['full_name'],
      'userPicUrl': userInfo.data()!['userPicUrl'],
    });
    FirebaseFirestore.instance
        .collection('recent_chat')
        .doc(otherUserId)
        .collection('messages')
        .add({
      'chatromId': widget.ChatRoomId,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'text': enteredMessage,
      'name': userInfo.data()!['full_name'],
      'userPicUrl': userInfo.data()!['userPicUrl'],
    });
  }

  String getOtherUserId(String chatromId) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    var otherUserId = '';
    List<String> parts = chatromId.split('_');
    for (var p in parts) {
      if (p != userID) {
        otherUserId = p;
      }
    }
    return otherUserId;
  }

  @override
  Widget build(BuildContext context) {
    print('Building with text: ${_messageController.text}');
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              minLines: 1,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                label: const Text(
                  'Send a message..',
                  style: TextStyle(fontSize: 15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(
              Icons.send_rounded,
              size: 33,
            ),
          ),
        ],
      ),
    );
  }
}
