import 'package:flutter/material.dart';
import 'package:shle_share/data/dummy_data.dart';
import 'package:shle_share/widget/book_view.dart';

class BookShelfScreen extends StatelessWidget {
  const BookShelfScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          for (var book in BookList)
            if (book.isFin)
              BookView(
                  id: book.id,
                  title: book.title,
                  bookImg: book.bookImg,
                  isFin: book.isFin,
                  isReq: book.isReq),
        ],
      ),
    );
  }
}
