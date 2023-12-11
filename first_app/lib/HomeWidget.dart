import 'package:first_app/Diceroller.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Text_Style.dart';
import 'package:first_app/Diceroller.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({super.key});

  @override
  Widget build(context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 78, 34, 255),
            Color.fromARGB(255, 100, 54, 181),
          ], begin: Alignment.topRight, end: Alignment.bottomCenter),
        ),
        child: Center(child: Diceroller()));
  }
}
