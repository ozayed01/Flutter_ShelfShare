import 'package:flutter/material.dart';
import 'package:shle_share/models/book.dart';
import 'package:shle_share/widget/book_details.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class BookView extends StatelessWidget {
  const BookView(
      {super.key,
      required this.id,
      required this.title,
      required this.bookImg,
      required this.isFin,
      required this.bookAuthor,
      required this.bookDescription,
      required this.relaseDate});
  final String id;
  final String title;
  final String bookImg;
  final String bookAuthor;
  final String bookDescription;
  final String relaseDate;
  final bool isFin;

  @override
  Widget build(BuildContext context) {
    final MyBook book1 = MyBook(
        id: id,
        title: title,
        bookImg: bookImg,
        bookAuthor: bookAuthor,
        bookDescription: bookDescription,
        relaseDate: relaseDate);
    String formattedDate(DateTime date) {
      return formatter.format(date);
    }

    void _selectBook(BuildContext context, String bookName) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BookDetails(book: book1),
      ));
    }

    return InkWell(
      onTap: () {
        _selectBook(context, title);
      },
      child: Stack(children: [
        Hero(
          tag: id,
          transitionOnUserGestures: true,
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(bookImg),
            fit: BoxFit.cover,
            height: 160 * 2,
            width: 100 * 2,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text((isFin) ? "Finished" : "Requested",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
          ),
        ),
      ]),
    );
  }
}
