import 'package:flutter/material.dart';
import 'package:shle_share/data/dummy_data.dart';
import 'package:shle_share/widget/book_view.dart';

class RequestedBook extends StatelessWidget {
  const RequestedBook({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      children: [
        for (var book in BookList)
          if (book.isReq)
            BookView(
                id: book.id,
                title: book.title,
                bookImg: book.bookImg,
                isFin: book.isFin,
                isReq: book.isReq),
      ],
    ));
  }
}
