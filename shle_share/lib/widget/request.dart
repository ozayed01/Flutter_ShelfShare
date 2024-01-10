import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shle_share/models/UserChatInfo.dart';
import 'package:shle_share/widget/user_profile.dart';

class Request extends StatefulWidget {
  const Request({
    super.key,
    required this.bookimgUrl,
    required this.bookDtails,
    required this.user,
    required this.exhangeText,
    required this.createdAt,
    required this.userLat,
    required this.userLng,
    required this.requestLat,
    required this.requestLng,
  });

  final String bookimgUrl;
  final List<String> bookDtails;
  final UserChatInfo user;

  final String exhangeText;

  final double userLat;
  final double userLng;
  final double requestLat;
  final double requestLng;

  final Timestamp createdAt;

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final _sameUser = userID == widget.user.userId;
    final List<String> details = ['Book: ', "Author: ", "Realase Date: "];
    for (int i = 0; i < 3; i++) {
      details[i] = "${details[i]}${widget.bookDtails[i]}.";
    }

    Future<void> deleteBookAndPost() async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        final postQuerySnapshot = await firestore
            .collection('Requests_feed')
            .where('userId', isEqualTo: userID)
            .where(
              'reqId',
              isEqualTo: userID + '_' + widget.bookDtails[0],
            )
            .limit(1)
            .get();

        if (postQuerySnapshot.docs.isNotEmpty) {
          final postRef = firestore
              .collection('Requests_feed')
              .doc(postQuerySnapshot.docs.first.id);

          final bookQuerySnapshot = await firestore
              .collection('book_shelf')
              .doc(userID)
              .collection('Requested')
              .where(
                'reqId',
                isEqualTo: userID + '_' + widget.bookDtails[0],
              )
              .limit(1)
              .get();

          if (bookQuerySnapshot.docs.isNotEmpty) {
            final bookRef = firestore
                .collection('book_shelf')
                .doc(userID)
                .collection('Requested')
                .doc(bookQuerySnapshot.docs.first.id);

            await firestore.runTransaction((transaction) async {
              transaction.delete(bookRef);
              transaction.delete(postRef);
            });

            print('Documents deleted successfully within transaction!');
          } else {
            print('Requested book document not found.');
          }
        } else {
          print('Post document not found.');
        }
      } catch (e, stackTrace) {
        print('Error deleting documents within transaction: $e');
        print('Stack trace: $stackTrace');
      }
    }

    String formatFirestoreTimestampToRegularDate(Timestamp firestoreTimestamp) {
      DateTime dateTime = firestoreTimestamp.toDate();
      DateTime now = DateTime.now();

      Duration difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds} seconds ago';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 3) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    }

    Future<void> _confirmDeleteDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content:
                const Text('Are you sure you want to delete this request?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  deleteBookAndPost();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    String calculateDistance(lat1, lon1, lat2, lon2) {
      if (lat1 == lat2 && lon1 == lon2) {
        return '0.0';
      }
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return (12742 * asin(sqrt(a))).toStringAsFixed(1);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 5,
            ),
            //pic and user Details
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (
                    context,
                  ) =>
                          UserProfile(
                            user: widget.user,
                          )),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 29,
                      backgroundColor: Colors.grey,
                      foregroundImage: NetworkImage(widget.user.userImgUrl)),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      Text(widget.user.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text(
                        '@${widget.user.username}',
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (_sameUser)
                    IconButton(
                        onPressed: _confirmDeleteDialog,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                ],
              ),
            ),
            //pic and user details end
            //requst
            const SizedBox(
              height: 20,
            ),
            Text(
              'Request : ${widget.exhangeText}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 17,
            ),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var detail in details)
                        Text(
                          detail,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.bookimgUrl,
                    height: 120,
                    width: 100,
                  ),
                ),
                const SizedBox(width: 20)
              ],
            ),
            //end of book details

            Row(
              children: [
                Icon(Icons.location_on),
                Text(
                    '${calculateDistance(widget.userLat, widget.userLng, widget.requestLat, widget.requestLng)} Km'),
                const Spacer(),
                Text(formatFirestoreTimestampToRegularDate(widget.createdAt))
              ],
            )
          ],
        ),
      ),
    );
  }
}
