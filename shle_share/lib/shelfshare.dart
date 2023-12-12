import 'package:flutter/material.dart';
import 'package:shle_share/startup_screen.dart';
import 'package:shle_share/login_screen.dart';
import 'package:shle_share/signup_screen.dart';

class ShelfShare extends StatefulWidget {
  const ShelfShare({super.key});

  @override
  State<ShelfShare> createState() {
    return _ShelfShareState();
  }
}

class _ShelfShareState extends State<ShelfShare> {
  Widget? activeScreen;

  @override
  void initState() {
    activeScreen = StartScreen(switchscreen: SwitchScreen);
    super.initState();
  }

  void SwitchScreen(Widget active) {
    setState(() {
      activeScreen = active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Color.fromARGB(255, 235, 232, 231),
          child: activeScreen,
        ),
      ),
    );
  }
}
