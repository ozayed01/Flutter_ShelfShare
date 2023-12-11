import 'package:flutter/material.dart';

class TextIn extends StatelessWidget {
  const TextIn(this.text, {super.key});
  final String text;
  Widget build(context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 50,
      ),
    );
  }
}
