import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shle_share/Book_finder/books_finder.dart';
import 'package:http/http.dart' as http;
import 'package:shle_share/models/my_book.dart';
import 'package:shle_share/widget/book_details.dart';
import 'dart:convert';
import 'package:shle_share/widget/book_view.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const String openaiUrl = 'https://api.openai.com/v1/chat/completions';
String apiKey =
    '${dotenv.env['openAi_APIKEY']}'; // Replace with your actual API key
int maxTokens = 150;

class BookReq extends StatefulWidget {
  const BookReq({super.key, required this.isSearch});
  final bool isSearch;

  @override
  State<BookReq> createState() => _BookReqState();
}

class _BookReqState extends State<BookReq> {
  bool isLoading = false;

  List<String> userbooks = [];
  List<Book> RecBooks = [];
  Future<String> getBookRecommendations(List<String> finBooks) async {
    try {
      final response = await http.post(
        Uri.parse(openaiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // the model here
          'messages': [
            {
              'role': 'user',
              'content':
                  'Given the book titles ${finBooks.join(', ')}, please recommend up to five books that are similar in terms of category, themes, or authorship. Provide only the titles of the books. use this format book1,book2,book3, etc..'
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['choices'] != null &&
            jsonResponse['choices'].isNotEmpty) {
          var firstChoice = jsonResponse['choices'][0];

          if (firstChoice['message']['content'] != null) {
            return firstChoice['message']['content'].trim();
          }
        }
        return 'No recommendations found.';
      } else {
        return 'Failed to load recommendations';
      }
    } catch (e) {
      return 'Exception caught in getBookRecommendations: $e';
    }
  }

  String formattedDate(DateTime date) {
    return formatter.format(date);
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;
  void UserRec() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userFinBooks = await FirebaseFirestore.instance
          .collection('book_shelf')
          .doc(userId)
          .collection('Finished')
          .get();

      List<String> booksName = [];
      for (var book in userFinBooks.docs) {
        booksName.add(book['book_name']);
      }

      if (booksName.isEmpty) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Err : No books added to your Finshed books')));
        return;
      } else {
        final res = await getBookRecommendations(booksName);
        userbooks = res.split(',');
        for (var book in userbooks) {
          searchAndgetBooks(book);
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error in UserRec: $e');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Err : $e')));
    }
  }

  void searchAndgetBooks(String bookname) async {
    final List<Book> booklist = await queryBooks(
      bookname,
      queryType: QueryType.intitle,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );
    setState(() {
      RecBooks.add(booklist[0]);
    });
  }

  Future<void> _confirmRecommendationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recommendations'),
          content: const Text(
              'Our AI-Powered recommendations are based on your finished books, So if you want to get recommendations you need to add books to your finished books.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                UserRec();
                Navigator.of(context).pop();
              },
              child: const Text('Contenue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      height: 270,
      width: double.infinity,
      child: Column(children: [
        const SizedBox(height: 40),
        const Text(
          'You don\'t know what to search for?',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _confirmRecommendationDialog,
          child: const Text(
            "Try our Recommendations",
            style: TextStyle(fontSize: 13),
          ),
        ),
      ]),
    );
    if (isLoading) {
      content = Center(child: CircularProgressIndicator());
    }
    if (RecBooks.isNotEmpty) {
      content = ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: RecBooks.length,
        itemBuilder: (ctx, index) {
          final bookData = RecBooks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: BookView(
              userId: userId,
              id: bookData.id,
              title: bookData.info.title,
              bookImg: '${bookData.info.imageLinks['thumbnail']!}',
              isFin: false,
              bookAuthor: bookData.info.authors.join(', '),
              bookDescription: bookData.info.description,
              relaseDate: '${formattedDate(bookData.info.publishedDate!)}',
              isOther: false,
              isReq: true,
            ),
          );
        },
      );
    }
    return Container(
      height: 270,
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: content,
    );
  }
}
