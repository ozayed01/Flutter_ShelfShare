import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';
import 'package:shle_share/models/my_book.dart';
import 'package:flutter/material.dart';

class BookDetailsSearch extends StatelessWidget {
  const BookDetailsSearch({super.key, required this.book});
  final MyBook book;

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
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
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('book_shelf')
                            .doc(userID)
                            .collection('Finished')
                            .add({
                          'book_id': book.id,
                          'book_name': book.title,
                          'book_auther': book.bookAuthor,
                          'book_image': book.bookImg,
                          'book_description': book.bookDescription,
                          'relase_date': book.relaseDate,
                          'createdAt': Timestamp.now(),
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'The Book is Added to Finished Books')));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                      ),
                      label: const Text('Already Read'),
                      icon: const Icon(Icons.check),
                    )
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
