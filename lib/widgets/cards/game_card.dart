import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latimovies/screens/game_details_screen.dart';

import '../../models/game_model.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.gameModel});
  final GameModel gameModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => GameDetailsScreen(
                      gameId: gameModel.id.toString(),
                    )));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GridTile(
            header: Container(
              height: 60,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black87, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          gameModel.genre,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            if (gameModel.platform
                                .toUpperCase()
                                .contains("Windows".toUpperCase()))
                              const Icon(
                                FontAwesomeIcons.computer,
                                color: Colors.white,
                                size: 16,
                              ),
                            if (gameModel.platform
                                    .toUpperCase()
                                    .contains("web".toUpperCase()) &&
                                gameModel.platform
                                    .toUpperCase()
                                    .contains("Windows".toUpperCase()))
                              const SizedBox(
                                width: 15,
                              ),
                            if (gameModel.platform
                                .toUpperCase()
                                .contains("web".toUpperCase()))
                              const Icon(
                                FontAwesomeIcons.globe,
                                color: Colors.white,
                                size: 16,
                              ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            footer: Container(
              height: 80,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black87, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      gameModel.publisher,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: AutoSizeText(
                          gameModel.title,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          maxFontSize: 16,
                          minFontSize: 10,
                          maxLines: 2,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            child: Container(
                color: Colors.black12,
                child: Image.network(
                  gameModel.thumbnail,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    return loadingProgress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ))),
      ),
    );
  }
}
