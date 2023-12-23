import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Profile/BookShelf_screen.dart';
import 'package:shle_share/BottomBar/Profile/requested_book.dart';
import 'package:shle_share/BottomBar/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.fullName,
    required this.username,
    required this.userImg,
    this.userBio,
  });
  final String username;
  final String fullName;
  final String userImg;
  final String? userBio;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Profile'),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Container(
                height: 220,
                width: 400,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        userImg,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Text(
                      fullName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                letterSpacing: 1.2,
                              ),
                    ),
                    Text(
                      "@$username",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7)),
                    ),
                    const SizedBox(height: 32),
                    if (userBio != null) Text(userBio!),
                  ],
                ),
              ),
            ),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.loop_rounded)),
                Tab(icon: Icon(Icons.book_outlined)),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  RequestedBook(),
                  BookShelfScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
