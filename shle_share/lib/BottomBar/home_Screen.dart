import 'package:flutter/material.dart';
import 'package:shle_share/data/dummy_data.dart';
import 'package:shle_share/widget/add_requst.dart';
import 'package:shle_share/widget/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _openAddRequestOverlay() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => (AddRequest()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: _openAddRequestOverlay,
              icon: const Icon(Icons.add_box))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var post in Posts)
              Post(
                  bookDtails: post.bookDtails,
                  username: post.username,
                  name: post.name,
                  userImgUrl: post.userImgUrl,
                  exhangeText: post.exhangeText),
          ],
        ),
      ),
    );
  }
}
