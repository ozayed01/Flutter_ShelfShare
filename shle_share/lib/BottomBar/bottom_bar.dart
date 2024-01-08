import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Profile/profile_Screen.dart';
import 'package:shle_share/BottomBar/map.dart';
import 'package:shle_share/BottomBar/request_feed.dart';
import 'package:shle_share/BottomBar/search_screen.dart';
import 'package:shle_share/Screens/chat/chat_users.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  var name = '';
  var username = '';
  var userPic = '';
  var bio = '';

  void _selectedPageIndex(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = RequestFeedScreen();
    var activePageTitle = 'Request Feed';

    void setUser() async {
      final user = FirebaseAuth.instance.currentUser!;
      final userInfo = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      setState(() {
        name = userInfo.data()!['full_name'];
        username = userInfo.data()!['username'];
        userPic = userInfo.data()!['userPicUrl'];
        bio = userInfo.data()!['Bio'];
      });
    }

    if (_selectedIndex == 1) {
      activePage = const SearchScreen();
      activePageTitle = 'Search';
    }
    if (_selectedIndex == 2) {
      activePage = MapScreen();
      activePageTitle = "Map";
    } else if (_selectedIndex == 3) {
      activePage = ChatUserList();
      activePageTitle = 'Chat';
    } else if (_selectedIndex == 4) {
      setUser();
      activePage = ProfileScreen(
        fullName: name,
        username: username,
        userImg: userPic,
        userBio: bio,
        IsOtherUser: false,
      );
      activePageTitle = 'Profile';
    }
    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _selectedPageIndex,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
