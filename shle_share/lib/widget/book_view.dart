import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/models/book.dart';
import 'package:shle_share/widget/book_details.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class BookView extends StatelessWidget {
  const BookView({
    super.key,
    required this.id,
    required this.title,
    required this.bookImg,
    required this.isFin,
  });
  final String id;
  final String title;
  final String bookImg;
  final bool isFin;

  @override
  Widget build(BuildContext context) {
    String formattedDate(DateTime date) {
      return formatter.format(date);
    }

    void _selectBook(BuildContext context, String bookName) async {
      final List<Book> booklist = await queryBooks(
        bookName,
        queryType: QueryType.intitle,
        maxResults: 1,
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookDetails(
            book: MyBook(
              id: id,
              title: booklist[0].info.title,
              bookImg: '${booklist[0].info.imageLinks['thumbnail']}',
              bookAuthor: booklist[0].info.authors[0],
              relaseDate: formattedDate(booklist[0].info.publishedDate!),
              bookDescription: booklist[0].info.description,
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        _selectBook(context, 'Fire and Blood');
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
