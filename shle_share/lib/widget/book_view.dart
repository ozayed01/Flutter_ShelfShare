import 'package:flutter/material.dart';
import 'package:shle_share/models/book.dart';
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
    Book(bookImg: bookImg, id: id, title: title);
    return Stack(children: [
      FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(bookImg),
        fit: BoxFit.cover,
        height: 160 * 2,
        width: 100 * 2,
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text((isFin) ? "Finished it" : "Requested it",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
        ),
      ),
    ]);
  }
}
