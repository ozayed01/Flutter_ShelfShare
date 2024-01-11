import 'dart:io';
import 'package:shle_share/Book_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shle_share/BottomBar/search_screen.dart';

final formatter = DateFormat.yMd();
String formattedDate(DateTime date) {
  return formatter.format(date);
}

class BookInputPicker extends StatefulWidget {
  const BookInputPicker({
    super.key,
    required this.onBookPicked,
  });
  final Function(Book) onBookPicked;

  @override
  State<BookInputPicker> createState() {
    return _BookInputPickerState();
  }
}

class _BookInputPickerState extends State<BookInputPicker> {
  late Book _SelectedBook;
  var _isPicked = false;

  void _pickBook() async {
    final pickedBook = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchScreen(isfromReq: true),
      ),
    );

    if (pickedBook != null) {
      setState(() {
        _SelectedBook = pickedBook;
        _isPicked = true;
        widget.onBookPicked(_SelectedBook);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: _pickBook,
        icon: Icon(Icons.add_rounded,
            color: Theme.of(context).colorScheme.onBackground),
        label: Text(
          'Add The Book You Want',
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ));

    if (_isPicked) {
      content = InkWell(
        onTap: _pickBook,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                '${_SelectedBook.info.imageLinks['thumbnail']}',
                height: 300,
                width: 200,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _SelectedBook.info.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _SelectedBook.info.authors[0],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    formattedDate(_SelectedBook.info.publishedDate!),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
          ),
        ),
        height: 260,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
