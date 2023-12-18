import 'package:flutter/material.dart';
import 'package:shle_share/shelfshare.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 56, 33, 16));
var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 23, 14, 7));
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.secondary,
            foregroundColor: kColorScheme.onSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kColorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
          ),
        ),
      ),
      theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.secondaryContainer,
            foregroundColor: kColorScheme.onSecondaryContainer,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primary,
              foregroundColor: kColorScheme.onPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
            foregroundColor: kColorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
          ))),
      home: const ShelfShare(),
    );
  }
}
