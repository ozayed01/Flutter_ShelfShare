import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:books_finder/books_finder.dart';
import 'package:shle_share/widget/book_input_picker.dart';

final formatter = DateFormat.yMd();

class AddRequest extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddRequest> createState() {
    return _addRequestState();
  }
}

class _addRequestState extends ConsumerState<AddRequest> {
  final _requestTextController = TextEditingController();
  Book? _theBook;

  void _updateSelectedBook(Book? book) {
    setState(() {
      _theBook = book;
    });
  }

  var Date = DateTime.now();

  String formattedDate(DateTime date) {
    return formatter.format(date);
  }

  void _addPost(Book book) async {
    final enteredText = _requestTextController.text;

    if (enteredText.isEmpty) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userInfo = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('Books').doc(book.id).set({
      'book_id': book.id,
      'book_name': book.info.title,
      'book_auther': book.info.authors[0],
      'book_image': '${book.info.imageLinks['thumbnail']}',
      'book_description': book.info.description,
      'book_genra': (book.info.categories.length > 1)
          ? book.info.categories[0] + ',' + book.info.categories[1]
          : book.info.categories[0],
      'relase_date': formattedDate(book.info.publishedDate!),
      'createdAt': Timestamp.now(),
    });

    FirebaseFirestore.instance
        .collection('book_shelf')
        .doc(user.uid)
        .collection('Requested')
        .add({
      'reqId': user.uid + '_' + book.info.title,
      'book_id': book.id,
      'book_name': book.info.title,
      'book_auther': book.info.authors[0],
      'book_image': '${book.info.imageLinks['thumbnail']}',
      'book_description': book.info.description,
      'relase_date': formattedDate(book.info.publishedDate!),
      'createdAt': Timestamp.now(),
    });
    FirebaseFirestore.instance.collection('Requests_feed').add({
      'reqId': user.uid + '_' + book.info.title,
      'request_text': enteredText,
      'full_name': userInfo.data()!['full_name'],
      'username': userInfo.data()!['username'],
      'userPicUrl': userInfo.data()!['userPicUrl'],
      'Bio': userInfo.data()!['Bio'],
      'userId': user.uid,
      'book_name': book.info.title,
      'book_auther': book.info.authors[0],
      'book_image': '${book.info.imageLinks['thumbnail']}',
      'relase_date': formattedDate(book.info.publishedDate!),
      'createdAt': Timestamp.now(),
    });
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
                child: Text("Post a Requst",
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
            BookInputPicker(onBookPicked: _updateSelectedBook),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
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
                      if (_theBook != null) {
                        _addPost(_theBook!);
                      } else {
                        print('book didnt go');
                      }
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
