import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latimovies/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Gamify",
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
