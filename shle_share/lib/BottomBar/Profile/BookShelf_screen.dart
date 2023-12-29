import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/data/dummy_data.dart';
import 'package:shle_share/widget/book_view.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class BookShelfScreen extends StatefulWidget {
  const BookShelfScreen({super.key});

  @override
  State<BookShelfScreen> createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends State<BookShelfScreen> {
  String formattedDate(DateTime date) {
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    setBook(String bookName) async {
      final List<Book> booklist = await queryBooks(
        bookName,
        queryType: QueryType.intitle,
        maxResults: 1,
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
      );
      return BookView(
        title: booklist[0].info.title,
        bookImg: '${booklist[0].info.imageLinks['thumbnail']}',
        id: booklist[0].id,
        bookAuthor: booklist[0].info.authors[0],
        bookDescription: booklist[0].info.description,
        relaseDate: formattedDate(booklist[0].info.publishedDate!),
        isFin: true,
      );
    }

    return Scaffold(
      body: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          for (var book in BookList)
            if (book.isFin)
              FutureBuilder(
                  future: setBook(book.BookName),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.isFin) {
                      return BookView(
                        id: snapshot.data!.id,
                        title: snapshot.data!.title,
                        bookImg: snapshot.data!.bookImg,
                        bookAuthor: snapshot.data!.bookAuthor,
                        bookDescription: snapshot.data!.bookDescription,
                        relaseDate: snapshot.data!.relaseDate,
                        isFin: snapshot.data!.isFin,
                      );
                    }
                    return Text('err');
                  })
        ],
      ),
    );
  }
}
