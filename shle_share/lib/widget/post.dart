import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    this.ImgUrl,
    required this.booktitle,
    required this.username,
    required this.name,
    required this.userImgUrl,
  });

  final String? ImgUrl;
  final String booktitle;
  final String name;
  final String username;
  final String userImgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      width: 500,
      height: 300,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
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
                height: 70,
                width: 70,
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
          height: 100,
        ),

        Text(booktitle)
      ]),
    );
  }
}
