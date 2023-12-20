import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    this.ImgUrl,
    required this.bookDtails,
    required this.username,
    required this.name,
    required this.userImgUrl,
    required this.exhangeText,
  });

  final String? ImgUrl;
  final List<String> bookDtails;
  final String name;
  final String username;
  final String userImgUrl;
  final String exhangeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      width: 500,
      height: 190,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 5,
        ),

        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                userImgUrl,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(children: [
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      letterSpacing: 1.2,
                    ),
              ),
              Text(username),
            ]),
          ],
        ),
        // if (ImgUrl != null)
        //   Image.network(
        //     ImgUrl!,
        //     height: 150,
        //     width: 500,
        //   )
        SizedBox(
          height: 20,
        ),
        Text(' Request Title : $exhangeText'),
        SizedBox(
          height: 20,
        ),

        Row(
          children: [
            Column(
              children: [
                for (var book in bookDtails)
                  Text(
                    ' $book',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
