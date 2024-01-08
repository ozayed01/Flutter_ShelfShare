import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

    if (enteredText.isEmpty) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userInfo = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance
        .collection('Books')
        .doc(user.uid)
        .collection('Requested')
        .add({
      'request_text': enteredText,
      'full_name': userInfo.data()!['full_name'],
      'username': userInfo.data()!['username'],
      'userPicUrl': userInfo.data()!['userPicUrl'],
      'Bio': userInfo.data()!['Bio'],
      'userId': user.uid,
      'book_name': booklist[0].info.title,
      'book_auther': booklist[0].info.authors[0],
      'book_image': ('${booklist[0].info.imageLinks['thumbnail']}' == 'null')
          ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbJk-qCpmshndFRatcLSOB8GsyboaySnGpeS2GvkZsQShaZpccKqkkK4MkBRGbIVOBnzw&usqp=CAU'
          : '${booklist[0].info.imageLinks['thumbnail']}',
      'relase_date': formattedDate(booklist[0].info.publishedDate!),
      'createdAt': Timestamp.now(),
    });
    FirebaseFirestore.instance.collection('Requests_feed').add({
      'request_text': enteredText,
      'full_name': userInfo.data()!['full_name'],
      'username': userInfo.data()!['username'],
      'userPicUrl': userInfo.data()!['userPicUrl'],
      'Bio': userInfo.data()!['Bio'],
      'userId': user.uid,
      'book_name': booklist[0].info.title,
      'book_auther': booklist[0].info.authors[0],
      'book_image': '${booklist[0].info.imageLinks['thumbnail']}',
      'relase_date': formattedDate(booklist[0].info.publishedDate!),
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
