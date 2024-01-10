import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/widget/book_view.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class FinishedBook extends StatefulWidget {
  const FinishedBook({
    Key? key,
    this.userId,
  });
  final String? userId;
  @override
  State<FinishedBook> createState() => _FinishedBookState();
}

class _FinishedBookState extends State<FinishedBook> {
  @override
  Widget build(BuildContext context) {
    var isOther;
    var _userId = '';
    if (widget.userId == null) {
      _userId = FirebaseAuth.instance.currentUser!.uid;
      isOther = false;
    } else {
      _userId = widget.userId!;
      isOther = true;
    }
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('book_shelf')
            .doc(_userId)
            .collection('Finished')
            .snapshots(),
        builder: (ctx, requestSnapshot) {
          if (requestSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!requestSnapshot.hasData || requestSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Finshed Books were found!'),
            );
          }
          if (requestSnapshot.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }
          final requestedBooks = requestSnapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: requestedBooks.length,
            itemBuilder: (ctx, index) {
              print(requestedBooks.length);
              final bookData =
                  requestedBooks[index].data() as Map<String, dynamic>;

              return BookView(
                id: bookData['book_id'],
                title: bookData['book_name'],
                bookImg: bookData['book_image'],
                isFin: true,
                bookAuthor: bookData['book_auther'],
                bookDescription: bookData['book_description'],
                relaseDate: bookData['relase_date'],
                isOther: isOther,
              );
            },
          );
        },
      ),
    );
  }
}
