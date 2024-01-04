import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shle_share/models/user.dart';
import 'package:shle_share/providers/post_pro.dart';
import 'package:shle_share/widget/post.dart';
import 'package:shle_share/data/dummy_data.dart';
import 'package:books_finder/books_finder.dart';

final formatter = DateFormat.yMd();

class AddRequest extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddRequest> createState() {
    return _addRequestState();
  }
}

class _addRequestState extends ConsumerState<AddRequest> {
  final _requestTextController = TextEditingController();
  final _bookNameController = TextEditingController();
  var Date = DateTime.now();

  String formattedDate(DateTime date) {
    return formatter.format(date);
  }

  void _addPost(String bookName) async {
    final List<Book> booklist = await queryBooks(
      bookName,
      queryType: QueryType.intitle,
      maxResults: 1,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );
    final enteredText = _requestTextController.text;

    final post = Post(
      bookDtails: [
        booklist[0].info.title,
        booklist[0].info.authors[0],
        formattedDate(booklist[0].info.publishedDate!)
      ],
      user: user,
      bookimgUrl: '${booklist[0].info.imageLinks['thumbnail']}',
      exhangeText: enteredText,
      Date: formattedDate(Date),
    );
    print(booklist[0].id);
    if (enteredText.isEmpty) {
      return;
    }
    ref.read(postProvider.notifier).addPost(post);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _requestTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHight / 1.10,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                height: 70,
                child: Text("Post Requst",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            TextField(
              controller: _requestTextController,
              decoration: InputDecoration(
                label: const Text(
                  'Type Your Request',
                  style: TextStyle(fontSize: 17),
                ),
                prefixIcon: const Icon(Icons.help),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bookNameController,
              decoration: InputDecoration(
                label: const Text(
                  'Book Name',
                  style: TextStyle(fontSize: 17),
                ),
                prefixIcon: const Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      _addPost(_bookNameController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 15),
                    ),
                    child: const Text('Post')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
