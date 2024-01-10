import 'package:shle_share/widget/request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostNotifier extends StateNotifier<List<Request>> {
  PostNotifier() : super(const []);

  void addPost(Request post) {
    state = [post, ...state];
  }
}

final postProvider =
    StateNotifierProvider<PostNotifier, List<Request>>((ref) => PostNotifier());
