import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Profile/finished_book.dart';
import 'package:shle_share/BottomBar/Profile/profile_drawr.dart';
import 'package:shle_share/BottomBar/Profile/requested_book.dart';
import 'package:shle_share/BottomBar/Admin/users_admin.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(
      {super.key,
      required this.fullName,
      required this.username,
      required this.userImg,
      this.userBio,
      required this.IsOtherUser,
      this.otherUserId,
      required this.isAdmin});
  final String username;
  final String fullName;
  final String userImg;
  final String? userBio;
  final bool IsOtherUser;
  final bool isAdmin;
  final String? otherUserId;
  @override
  Widget build(BuildContext context) {
    Widget content = DefaultTabController(
      length: 2,
      child: Scaffold(
        endDrawer: const ProfileDrawr(isAdmin: false),
        appBar: AppBar(
          title: const Text('Your Profile'),
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
                Tab(icon: Icon(Icons.menu_book_outlined)),
                Tab(icon: Icon(Icons.book_outlined)),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  RequestedBook(),
                  FinishedBook(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (IsOtherUser) {
      content = DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
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
                  Tab(icon: Icon(Icons.menu_book_outlined)),
                  Tab(icon: Icon(Icons.book_outlined)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    RequestedBook(userId: otherUserId!),
                    FinishedBook(userId: otherUserId),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (isAdmin) {
      content = AdminUsersList(
        AdminName: fullName,
      );
    }
    return content;
  }
}
