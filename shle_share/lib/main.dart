import 'package:flutter/material.dart';
import 'package:shle_share/shelfshare.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const ShelfShare();
  }
}
