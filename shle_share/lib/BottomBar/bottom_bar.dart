import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Admin/add_ticket.dart';
import 'package:shle_share/BottomBar/Profile/profile_Screen.dart';
import 'package:shle_share/BottomBar/map.dart';
import 'package:shle_share/BottomBar/request_feed.dart';
import 'package:shle_share/BottomBar/search_screen.dart';
import 'package:shle_share/Screens/chat/chat_recent.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  int _adminSelectedIndex = 0;
  var name = '';
  var username = '';
  var userPic = '';
  var bio = '';
  var userId = '';
  var isLoading = false;
  var isAdmin = false;
  var isActive = true;

  void _selectedPageIndex(int index) async {
    setState(() {
      if (!isAdmin) {
        _selectedIndex = index;
      } else {
        _adminSelectedIndex = index;
      }
    });
  }

  void setUser() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser!;
    final userInfo = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    setState(() {
      userId = user.uid;
      name = userInfo.data()!['full_name'];
      username = userInfo.data()!['username'];
      userPic = userInfo.data()!['userPicUrl'];
      bio = userInfo.data()!['Bio'];
      isLoading = false;
      isAdmin = userInfo.data()!['isAdmin'];
      isActive = userInfo.data()!['isActive'];
    });
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void _openAddTicketOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => (AddTicket()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (!isActive) {
      content = Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 150,
              ),
              Text(
                'Your Account is successfully deleted',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold ),
              ),
              const SizedBox(height: 20),
              Text(
                'All associated data has will be removed. If you wish to restore your account, please click the button below to submit a ticket.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.black, fontSize: 13),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                  onPressed: _openAddTicketOverlay,
                  child: const Text('Contact Support')),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const BottomBar()));
                  },
                  icon: const Icon(Icons.refresh)), 
                  TextButton(onPressed: (){
                    FirebaseAuth.instance.signOut();
                  }, child:  const Text('Sign Out' , style: TextStyle(
                    color: Colors.red
                  ),))
            ],
          ),
        )),
      );
    } else if (isAdmin) {
      Widget activePage = const RequestFeedScreen();
      if (_adminSelectedIndex == 1) {
        setUser();
        if (isLoading) {
          activePage = const Center(
            child: CircularProgressIndicator(),
          );
        }
        activePage = ProfileScreen(
          fullName: name,
          userId: userId,
          username: username,
          userImg: userPic,
          userBio: bio,
          isAdmin: isAdmin,
          IsOtherUser: false,
        );
      }

      content = Scaffold(
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.secondary,
          onTap: _selectedPageIndex,
          currentIndex: _adminSelectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
          ],
        ),
      );
    } else {
      Widget activePage = RequestFeedScreen();
      if (_selectedIndex == 1) {
        activePage = const SearchScreen(isfromReq: false);
      }
      if (_selectedIndex == 2) {
        activePage = MapScreen();
      } else if (_selectedIndex == 3) {
        activePage = const ChatRecentList();
      } else if (_selectedIndex == 4) {
        setUser();
        if (isLoading) {
          activePage = const Center(
            child: CircularProgressIndicator(),
          );
        }
        activePage = ProfileScreen(
          fullName: name,
          username: username,
          userImg: userPic,
          userBio: bio,
          userId: userId,
          isAdmin: isAdmin,
          IsOtherUser: false,
        );
      }
      content = Scaffold(
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

    return content;
  }
}
