import 'package:flutter/material.dart';
import 'package:shle_share/login_screen.dart';
import 'package:shle_share/signup_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key, required this.switchscreen});
  final Function switchscreen;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('welcom'),
          const SizedBox(
            height: 100,
          ),
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/1728/1728914.png',
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 300,
          ),
          ElevatedButton(
              onPressed: () {
                switchscreen(SignupPage());
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                  backgroundColor: Color.fromARGB(255, 56, 33, 16),
                  foregroundColor: Colors.white),
              child: Text('Sign up')),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                switchscreen(LoginPage());
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                backgroundColor: Colors.white,
                foregroundColor: Color.fromARGB(255, 56, 33, 16),
              ),
              child: Text('Sign in')),
        ],
      ),
    );
  }
}
