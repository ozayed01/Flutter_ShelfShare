import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shle_share/Book_finder/books_finder.dart';
import 'package:shle_share/widget/book_input_picker.dart';

final formatter = DateFormat.yMd();

class AddRequest extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddRequest> createState() {
    return _addRequestState();
  }
}

class _addRequestState extends ConsumerState<AddRequest> {
  final _requestTextController = TextEditingController();
  Book? _theBook;
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  double? currentLng;
  double? currentLat;
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    setState(() {
      currentLat = lat;
      currentLng = lng;
    });
  }

  void _updateSelectedBook(Book? book) {
    setState(() {
      _theBook = book;
    });
  }

  var Date = DateTime.now();

  String formattedDate(DateTime date) {
    print('reached Date But an err');

    if (date.year < 1000) {
      date = DateTime(date.year + 2000, date.month, date.day);
    }

    return formatter.format(date);
  }

  void _addPost(Book book) async {
    final enteredText = _requestTextController.text;

    if (enteredText.isEmpty) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userInfo = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    String releaseDate = book.info.publishedDate != null
        ? formattedDate(book.info.publishedDate!)
        : 'Not Available';
    if (book.info.categories.isEmpty) {}
    FirebaseFirestore.instance.collection('Books').doc(book.id).set({
      'book_id': book.id,
      'book_name': book.info.title,
      'book_auther': book.info.authors[0],
      'book_image': '${book.info.imageLinks['thumbnail']}',
      'book_description': book.info.description,
      'book_genra':
          (book.info.categories.isEmpty) ? 'No Genra' : book.info.categories[0],
      'relase_date': releaseDate,
      'createdAt': Timestamp.now(),
    });

    FirebaseFirestore.instance
        .collection('book_shelf')
        .doc(user.uid)
        .collection('Requested')
        .add({
      'reqId': user.uid + '_' + book.info.title,
      'book_id': book.id,
      'book_name': book.info.title,
      'book_auther': book.info.authors[0],
      'book_image': '${book.info.imageLinks['thumbnail']}',
      'book_description': book.info.description,
      'relase_date': releaseDate,
      'createdAt': Timestamp.now(),
    });
    FirebaseFirestore.instance.collection('Requests_feed').add({
      'reqId': user.uid + '_' + book.info.title,
      'request_text': enteredText,
      'full_name': userInfo.data()!['full_name'],
      'username': userInfo.data()!['username'],
      'userPicUrl': userInfo.data()!['userPicUrl'],
      'Bio': userInfo.data()!['Bio'],
      'userId': user.uid,
      'userLat': currentLat,
      'userLng': currentLng,
      'book_name': book.info.title,
      'book_auther': book.info.authors[0],
      'book_image': '${book.info.imageLinks['thumbnail']}',
      'relase_date': releaseDate,
      'createdAt': Timestamp.now(),
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _requestTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHight / 1.10,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                height: 70,
                child: Text("Post a Requst",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            TextField(
              controller: _requestTextController,
              decoration: InputDecoration(
                label: const Text(
                  'Type Your Request',
                  style: TextStyle(fontSize: 17),
                ),
                prefixIcon: const Icon(Icons.help),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 10),
            BookInputPicker(onBookPicked: _updateSelectedBook),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_theBook != null) {
                        _addPost(_theBook!);
                      } else {
                        print('book didnt go');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 15),
                    ),
                    child: const Text('Post')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
