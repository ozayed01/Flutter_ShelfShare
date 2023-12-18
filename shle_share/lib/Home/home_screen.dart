import 'package:flutter/material.dart';
import 'package:shle_share/Home/navItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _homeScreenState();
  }
}

class _homeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  BottomNavigationBarType _bottomNavType = BottomNavigationBarType.fixed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home Screen'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Page ${_navBarItems[_selectedIndex].label}'),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          type: _bottomNavType,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
    );
  }
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.bookmark_border_outlined),
    activeIcon: Icon(Icons.bookmark_rounded),
    label: 'Bookmarks',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.shopping_bag_outlined),
    activeIcon: Icon(Icons.shopping_bag),
    label: 'Cart',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
];
