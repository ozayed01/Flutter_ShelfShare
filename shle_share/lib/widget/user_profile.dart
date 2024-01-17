import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Profile/profile_Screen.dart';
import 'package:shle_share/models/UserChatInfo.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.user});
  final UserChatInfo user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name}\'s Profile'),
      ),
      body: ProfileScreen(
        otherUserId: user.userId,
        fullName: user.name,
        username: user.username,
        userImg: user.userImgUrl,
        userBio: user.userbio,
        IsOtherUser: true,
      ),
    );
  }
}
