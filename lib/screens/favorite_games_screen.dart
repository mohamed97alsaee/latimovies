import 'package:flutter/material.dart';

class FvoriteGamesScreen extends StatefulWidget {
  const FvoriteGamesScreen({super.key});

  @override
  State<FvoriteGamesScreen> createState() => _FvoriteGamesScreenState();
}

class _FvoriteGamesScreenState extends State<FvoriteGamesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("FvoriteGamesScreen"),
      ),
    );
  }
}
