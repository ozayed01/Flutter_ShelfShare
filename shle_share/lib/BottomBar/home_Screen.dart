import 'package:flutter/material.dart';
import 'package:shle_share/widget/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 2,
        ),
        child: Column(
          children: [
            Post(
              name: "Saleh",
              bookDtails: ['Harry Potter', 'J.K.Rowling', '20/2/2001'],
              username: '@iSelphiole',
              exhangeText: 'Hey, I\'m looking to exhange this book ',
              userImgUrl:
                  'https://static01.nyt.com/images/2022/10/24/arts/24taylor-notebook3/24taylor-notebook3-superJumbo.jpg',
              ImgUrl:
                  'https://images.unsplash.com/photo-1503756234508-e32369269deb?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dGhlJTIwc2VhfGVufDB8fDB8fHww',
            ),
            Post(
              name: "Saleh",
              bookDtails: ['Harry Potter', 'J.K.Rowling', '20/2/2001'],
              username: '@iSelphiole',
              exhangeText: 'Hey, I\'m looking to exhange this book ',
              userImgUrl:
                  'https://static01.nyt.com/images/2022/10/24/arts/24taylor-notebook3/24taylor-notebook3-superJumbo.jpg',
              ImgUrl:
                  'https://images.unsplash.com/photo-1503756234508-e32369269deb?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dGhlJTIwc2VhfGVufDB8fDB8fHww',
            ),
          ],
        ),
      ),
    );
  }
}
