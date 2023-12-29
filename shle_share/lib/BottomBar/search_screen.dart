import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/models/book.dart';
import 'package:shle_share/widget/book_details.dart';
import 'package:shle_share/widget/book_details_search.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var isLoading = true;
  List<Book> _searchBookList = [];
  final _searchControllr = TextEditingController();

  void _loadItems() async {
    final List<Book> booklist = await queryBooks(
      _searchControllr.text,
      queryType: QueryType.intitle,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );
    setState(() {
      _searchBookList = booklist;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate(DateTime date) {
      return formatter.format(date);
    }

    void _goTobook(BuildContext context, Book book) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookDetailsSearch(
            book: MyBook(
              id: book.id,
              title: book.info.title,
              bookImg: '${book.info.imageLinks['thumbnail']}',
              bookAuthor: book.info.authors[0],
              relaseDate: formattedDate(book.info.publishedDate!),
              bookDescription: book.info.description,
            ),
          ),
        ),
      );
    }

    Widget content = const Center(child: Text('no search resault yest'));
    if (isLoading && _searchBookList.isNotEmpty) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_searchBookList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _searchBookList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            _goTobook(context, _searchBookList[index]);
          },
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Row(children: [
              Hero(
                tag: _searchBookList[index].id,
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(
                      ('${_searchBookList[index].info.imageLinks['thumbnail']}' ==
                              'null')
                          ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbJk-qCpmshndFRatcLSOB8GsyboaySnGpeS2GvkZsQShaZpccKqkkK4MkBRGbIVOBnzw&usqp=CAU'
                          : '${_searchBookList[index].info.imageLinks['thumbnail']}'),
                  fit: BoxFit.fitHeight,
                  height: 160,
                  width: 100,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(_searchBookList[index].info.title,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 50),
                  Text("Author: ${_searchBookList[index].info.authors[0]}",
                      textAlign: TextAlign.left),
                  Text(
                    "Relase Date: ${formattedDate(_searchBookList[index].info.publishedDate!)}",
                    textAlign: TextAlign.left,
                  ),
                  if (_searchBookList[index].info.categories.isNotEmpty)
                    Text("Genre: ${_searchBookList[index].info.categories[0]}"),
                ],
              ),
            ]),
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 40,
            width: 350,
            child: TextField(
              onSubmitted: (value) {
                _loadItems();
              },
              controller: _searchControllr,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
              decoration: InputDecoration(
                filled: true,
                hintText: 'Search',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _loadItems,
              child: Text(
                'Search',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        ),
        body: content);
  }
}
