import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/home_screen.dart';
import 'package:shle_share/BottomBar/Profile/profile_Screen.dart';
import 'package:shle_share/BottomBar/map.dart';
import 'package:shle_share/BottomBar/search_screen.dart';
import 'package:shle_share/Screens/chat/chat.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _selectedPageIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = HomeScreen();

    var activePageTitle = 'Home';
    if (_selectedIndex == 1) {
      activePage = const SearchScreen();
      activePageTitle = 'Search';
    }
    if (_selectedIndex == 2) {
      activePage = MapScreen();
      activePageTitle = "Map";
    } else if (_selectedIndex == 3) {
      activePage = ChatScreen();
      activePageTitle = 'Chat';
    } else if (_selectedIndex == 4) {
      activePage = const ProfileScreen(
        fullName: 'osama',
        username: 'ozayed',
        userImg:
            'https://i.pinimg.com/564x/74/04/54/74045452c48b83ccb393a763d3e20872.jpg',
        userBio: 'I love Books so much | ADHD & Autsim ',
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
