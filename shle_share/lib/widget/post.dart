import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/models/UserChatInfo.dart';
import 'package:shle_share/widget/user_profile.dart';
import 'package:shle_share/models/UserChatInfo.dart';

class Post extends StatefulWidget {
  const Post({
    super.key,
    required this.bookimgUrl,
    required this.bookDtails,
    required this.user,
    required this.exhangeText,
    required this.Date,
  });

  final String bookimgUrl;
  final List<String> bookDtails;
  final UserChatInfo user;

  final String exhangeText;
  final String Date;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    final List<String> details = ['Book: ', "Author: ", "Realase Date: "];
    for (int i = 0; i < 3; i++) {
      details[i] = "${details[i]}${widget.bookDtails[i]}.";
    }

    // double calculateDistance(lat1, lon1, lat2, lon2) {
    //   var p = 0.017453292519943295;
    //   var c = cos;
    //   var a = 0.5 -
    //       c((lat2 - lat1) * p) / 2 +
    //       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    //   return 12742 * asin(sqrt(a));
    // }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
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
                  Spacer(),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert))
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
                Text('10 Km'),
                const Spacer(),
                Text(widget.Date)
              ],
            )
          ],
        ),
      ),
    );
  }
}
