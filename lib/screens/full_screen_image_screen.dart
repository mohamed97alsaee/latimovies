import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatelessWidget {
  const FullScreenImageScreen({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Center(child: Image.network(url)));
  }
}
