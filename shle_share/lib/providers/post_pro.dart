import 'package:shle_share/widget/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostNotifier extends StateNotifier<List<Post>> {
  PostNotifier() : super(const []);

  void addPost(Post post) {
    state = [post, ...state];
  }
}

final postProvider =
    StateNotifierProvider<PostNotifier, List<Post>>((ref) => PostNotifier());
