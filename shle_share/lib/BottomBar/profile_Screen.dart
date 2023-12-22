import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/home_screen.dart';
import 'book_library_page.dart';
import 'user_posts_page.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Icon and Bio
            CircleAvatar(
              backgroundImage: AssetImage('path/to/user_icon.jpg'),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              'User Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Bio: Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),

             TabBar(
            tabs: [
              Tab(icon: Icon(Icons.loop_rounded)),
              Tab(icon: Icon(Icons.book_outlined)),
            ],
          ),

            // TabBarView for Icons (Tabs)
            Expanded(
              child: TabBarView(
                children: [
                  // Profile Content
                  HomeScreen(),

                  // Book Library Content
                  // You can replace the Container widget with the BookLibraryPage widget if needed
                 HomeScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Your profile content goes here
    );
  }
}



