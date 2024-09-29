import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:latimovies/helpers/consts.dart';
import 'package:latimovies/models/game_model.dart';
import 'package:latimovies/widgets/cards/game_card.dart';

import '../models/detailed_game_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameDetailsScreen extends StatefulWidget {
  const GameDetailsScreen({super.key, required this.gameId});
  final String gameId;
  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  bool isLoading = false;

  DetailedGameModel? detailedGameModel;

  fetchGameById(String id) async {
    setState(() {
      isLoading = true;
    });
    // games.clear();
    final response =
        await http.get(Uri.parse("https://www.freetogame.com/api/game?id=$id"));

    if (kDebugMode) {
      print("REQUEST ON URL : https://www.freetogame.com/api/game?id=$id");
      print("STATUS CODE : ${response.statusCode}");
      print("BODY : ${response.body}");
    }

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      if (kDebugMode) {
        print("DECODED DATA :  ${jsonDecode(response.body)}");
      }
      detailedGameModel = DetailedGameModel.fromJson(decodedData);
      getGamesByCategory(detailedGameModel!.genre);

      setState(() {
        isLoading = false;
      });
    }
  }

  List<GameModel> similarGames = [];
  getGamesByCategory(String category) async {
    setState(() {
      isLoading = true;
    });
    similarGames.clear();
    final response = await http.get(
        Uri.parse("https://www.freetogame.com/api/games?category=$category"));

    if (kDebugMode) {
      print("STATUS CODE : ${response.statusCode}");
      print("BODY : ${response.body}");
    }

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      similarGames =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchGameById(widget.gameId);

    super.initState();
  }

  bool isShowMore = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          detailedGameModel == null ? "loading..." : detailedGameModel!.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
          child: isLoading && detailedGameModel == null
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                width: size.width,
                                detailedGameModel!.thumbnail,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                top: 16,
                                right: 16,
                                child: Row(
                                  children: [
                                    if (detailedGameModel!.platform
                                        .toUpperCase()
                                        .contains("Windows".toUpperCase()))
                                      const Icon(
                                        FontAwesomeIcons.computer,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    if (detailedGameModel!.platform
                                        .toUpperCase()
                                        .contains("web".toUpperCase()))
                                      const Icon(
                                        FontAwesomeIcons.globe,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                  ],
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            detailedGameModel!.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            detailedGameModel!.shortDescription,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detailedGameModel!.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: isShowMore ? 50 : 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShowMore = !isShowMore;
                                  });
                                },
                                child: Text(
                                  isShowMore ? "show less..." : "show more...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: blueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: detailedGameModel!.screenshots.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () {
                                    FullscreenImageViewer.open(
                                      context: context,
                                      child: Hero(
                                        tag: 'hero',
                                        child: Image.network(detailedGameModel!
                                            .screenshots[index].image),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: "hero",
                                    child: Image.network(
                                        fit: BoxFit.cover,
                                        detailedGameModel!
                                            .screenshots[index].image),
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        if (detailedGameModel!.minimumSystemRequirements !=
                            null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Minumum System Requirments",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "OS :${detailedGameModel!.minimumSystemRequirements!.os}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "MEMORY :${detailedGameModel!.minimumSystemRequirements!.memory}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "PROCESSOR :${detailedGameModel!.minimumSystemRequirements!.processor}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "GRAPHICS :${detailedGameModel!.minimumSystemRequirements!.graphics}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "STORAGE :${detailedGameModel!.minimumSystemRequirements!.storage}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Similar Games",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: size.height * 0.33,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: similarGames.length,
                              itemBuilder: (context, index) => SizedBox(
                                  height: 150,
                                  width: size.width * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: GameCard(
                                        gameModel: similarGames[index]),
                                  ))),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
