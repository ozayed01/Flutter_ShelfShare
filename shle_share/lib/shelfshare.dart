import 'package:flutter/material.dart';
import 'package:shle_share/startup_screen.dart';

class ShelfShare extends StatefulWidget {
  const ShelfShare({super.key});

  @override
  State<ShelfShare> createState() {
    return _ShelfShareState();
  }
}

class _ShelfShareState extends State<ShelfShare> {
  Widget activeScreen = StartScreen();

  void SwitchScreen(Widget active) {
    setState(() {
      activeScreen = active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: activeScreen,
      ),
    );
  }
}
