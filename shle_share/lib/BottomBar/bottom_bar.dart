import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/BookShelf_screen.dart';
import 'package:shle_share/BottomBar/chat_screen.dart';
import 'package:shle_share/BottomBar/home_screen.dart';
import 'package:shle_share/BottomBar/profile_Screen.dart';
import 'package:shle_share/BottomBar/search_screen.dart';

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
    } else if (_selectedIndex == 2) {
      activePage = const BookShelfScreen();
      activePageTitle = 'Book Shelf';
    } else if (_selectedIndex == 3) {
      activePage = const ChatScreen();
      activePageTitle = 'Chat';
    } else if (_selectedIndex == 4) {
      activePage = ProfileScreen();
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
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Book Shelf'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Measges'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
