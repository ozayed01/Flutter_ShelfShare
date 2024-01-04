import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shle_share/data/dummy_data.dart';
import 'package:shle_share/providers/post_pro.dart';
import 'package:shle_share/widget/add_requst.dart';
import 'package:shle_share/widget/post.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPosts = ref.watch(postProvider);
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
            for (var post in userPosts)
              Post(
                user: user,
                bookDtails: post.bookDtails,
                bookimgUrl: post.bookimgUrl,
                exhangeText: post.exhangeText,
                Date: post.Date,
              ),
          ],
        ),
      ),
    );
  }
}
