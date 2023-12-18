import 'package:flutter/material.dart';
import 'package:shle_share/Sign_in.dart';
import 'package:shle_share/Sign_up.dart';

class StartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartScreenState();
  }
}

class _StartScreenState extends State<StartScreen> {
  void _openSignInOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => (SignIn()),
    );
  }

  void _openSignUpOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => (SignUp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('welcom'),
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/1728/1728914.png',
            height: 300,
            width: 300,
          ),
          Column(
            //buttons
            children: [
              ElevatedButton(
                  onPressed: _openSignUpOverlay,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 15),
                  ),
                  child: Text('Sign up')),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                  onPressed: _openSignInOverlay, child: Text('Sign in')),
            ],
          )
        ],
      ),
    );
  }
}
