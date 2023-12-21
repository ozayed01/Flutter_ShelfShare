import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    this.bookimgUrl,
    required this.bookDtails,
    required this.username,
    required this.name,
    required this.userImgUrl,
    required this.exhangeText,
  });

  final String? bookimgUrl;
  final List<String> bookDtails;
  final String name;
  final String username;
  final String userImgUrl;
  final String exhangeText;
  final bool isfavOn = false;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    final List<String> details = ['Book: ', "Author: ", "Realase Date: "];

    for (int i = 0; i < 3; i++) {
      details[i] = details[i] + bookDtails[i];
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 5,
            ),
            //pic and user Details
            Row(
              children: [
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
                Column(
                  children: [
                    Text(
                      name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                letterSpacing: 1.2,
                              ),
                    ),
                    Text(username),
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
              ],
            ),
            //pic and user details end
            //requst
            const SizedBox(
              height: 20,
            ),
            Text(
              'Request : $exhangeText',
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
                if (bookimgUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      bookimgUrl!,
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
                const SizedBox(
                  width: 3,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                        (isfavOn)
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        size: 25,
                        color: (isfavOn)
                            ? Colors.red
                            : Theme.of(context).colorScheme.onBackground)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment,
                      size: 25,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      size: 25,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
