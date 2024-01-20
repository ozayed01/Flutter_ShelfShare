import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';
import 'package:shle_share/Screens/chat/chat.dart';
import 'package:shle_share/models/my_book.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/widget/add_requst.dart';

class BookDetails extends StatelessWidget {
  const BookDetails(
      {super.key,
      required this.book,
      required this.isFin,
      required this.isOther,
      required this.userId,
      required this.isFromReq});
  final MyBook book;
  final bool isFin;
  final bool isOther;
  final bool isFromReq;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;

    Future<void> _deleteBook() async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      if (isFin) {
        print(book.id);
        final bookQuerySnapshot = await firestore
            .collection('book_shelf')
            .doc(userID)
            .collection('Finished')
            .where(
              'book_id',
              isEqualTo: book.id,
            )
            .limit(1)
            .get();

        if (bookQuerySnapshot.docs.isNotEmpty) {
          final bookRef = firestore
              .collection('book_shelf')
              .doc(userID)
              .collection('Finished')
              .doc(bookQuerySnapshot.docs.first.id);

          await firestore.runTransaction((transaction) async {
            transaction.delete(bookRef);
          });
          print('deleted ');
          Navigator.of(context).pop();
          return;
        }
      }
      try {
        final postQuerySnapshot = await firestore
            .collection('Requests_feed')
            .where('userId', isEqualTo: userID)
            .where(
              'reqId',
              isEqualTo: userID + '_' + book.title,
            )
            .limit(1)
            .get();

        if (postQuerySnapshot.docs.isNotEmpty) {
          final postRef = firestore
              .collection('Requests_feed')
              .doc(postQuerySnapshot.docs.first.id);

          final bookQuerySnapshot = await firestore
              .collection('book_shelf')
              .doc(userID)
              .collection('Requested')
              .where(
                'reqId',
                isEqualTo: userID + '_' + book.title,
              )
              .limit(1)
              .get();

          if (bookQuerySnapshot.docs.isNotEmpty) {
            final bookRef = firestore
                .collection('book_shelf')
                .doc(userID)
                .collection('Requested')
                .doc(bookQuerySnapshot.docs.first.id);

            await firestore.runTransaction((transaction) async {
              transaction.delete(bookRef);
              transaction.delete(postRef);
            });

            print('Documents deleted successfully within transaction!');
          } else {
            print('Requested book document not found.');
          }
        } else {
          print('Post document not found.');
        }
      } catch (e, stackTrace) {
        print('Error deleting documents within transaction: $e');
        print('Stack trace: $stackTrace');
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Stack(children: [
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      book.title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Hero(
                          tag: book.id,
                          child: Image.network(
                            book.bookImg,
                            height: 260,
                            width: 150,
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          height: 300,
                          width: 220,
                          child: ScrollableTextIndicator(
                            text: Text(
                              book.bookDescription,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'The Auther:' + book.bookAuthor,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Relase Date :' + book.relaseDate,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    const SizedBox(height: 40),
                    if (!isOther && !isFromReq)
                      ElevatedButton(
                        onPressed: _deleteBook,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                        child: const Text('Remove Book'),
                      ),
                    if (isOther)
                      ElevatedButton.icon(
                          onPressed: () {
                            final meassage =
                                'Hey I would like to Exchange one of my books with Your Book (${book.title})';
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      useId: userId,
                                      text: meassage,
                                    )));
                          },
                          icon: const Icon(Icons.outgoing_mail),
                          label: const Text('Ask To Exhange')),
                    if (isFromReq)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                        child: const Text('Request Book'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
