import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shle_share/BottomBar/bottom_bar.dart';
import 'package:shle_share/Screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shle_share/Spalsh/Splash.dart';
import 'firebase_options.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 90, 63, 52),
);
var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 123, 81, 48));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.secondary,
          foregroundColor: kColorScheme.onSecondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primary,
              foregroundColor: kColorScheme.onPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kColorScheme.primary,
          ),
        ),
        textTheme: GoogleFonts.aDLaMDisplayTextTheme().copyWith(
          displayMedium: GoogleFonts.aboreto(),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapshot.hasData) {
            return const BottomBar();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
