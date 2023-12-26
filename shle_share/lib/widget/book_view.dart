import 'package:flutter/material.dart';
import 'package:shle_share/models/book.dart';
import 'package:shle_share/widget/book_details.dart';
import 'package:transparent_image/transparent_image.dart';

class BookView extends StatelessWidget {
  const BookView({
    super.key,
    required this.id,
    required this.title,
    required this.bookImg,
    required this.isFin,
    required this.isReq,
  });
  final String id;
  final String title;
  final String bookImg;
  final bool isFin;
  final bool isReq;

  @override
  Widget build(BuildContext context) {
    Book _book = Book(bookImg: bookImg, id: id, title: title, bookdetails: [
      'Name...',
      '20/02/2020',
      'Express yourself with a custom text design created just for you by a professional designer. Need ideas? We’ve collected some amazing examples of text images from our global community of designers. Get inspired and start planning the perfect text design today.'
    ]);
    void _selectBook(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookDetails(book: _book),
        ),
      );
    }

    return InkWell(
      onTap: () {
        _selectBook(context);
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
