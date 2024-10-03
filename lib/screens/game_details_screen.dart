import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:latimovies/helpers/consts.dart';
import 'package:latimovies/helpers/functions_helper.dart';
import 'package:latimovies/providers/games_provider.dart';
import 'package:latimovies/widgets/cards/game_card.dart';
import 'package:latimovies/widgets/cards/minimum_system_requirments_card.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class GameDetailsScreen extends StatefulWidget {
  const GameDetailsScreen({super.key, required this.gameId});
  final String gameId;
  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false)
        .fetchGameById(widget.gameId);

    super.initState();
  }

  bool isShowMore = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GamesProvider>(builder: (context, gamesConsumer, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            gamesConsumer.detailedGameModel == null
                ? "loading..."
                : gamesConsumer.detailedGameModel!.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
            child: gamesConsumer.busy && gamesConsumer.detailedGameModel == null
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
                                  gamesConsumer.detailedGameModel!.thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Row(
                                    children: [
                                      if (gamesConsumer
                                          .detailedGameModel!.platform
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
                                      if (gamesConsumer
                                          .detailedGameModel!.platform
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
                              gamesConsumer.detailedGameModel!.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    launchExtUrl(gamesConsumer
                                        .detailedGameModel!.gameUrl);
                                  },
                                  child: const Text(
                                    "Play Now",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              gamesConsumer.detailedGameModel!.shortDescription,
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
                                  gamesConsumer.detailedGameModel!.description,
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
                                    isShowMore
                                        ? "show less..."
                                        : "show more...",
                                    style: const TextStyle(
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
                              itemCount: gamesConsumer
                                  .detailedGameModel!.screenshots.length,
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
                                        child: Image.network(
                                          gamesConsumer.detailedGameModel!
                                              .screenshots[index].image,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            return loadingProgress == null
                                                ? child
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                          },
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                        fit: BoxFit.cover,
                                        gamesConsumer.detailedGameModel!
                                            .screenshots[index].image),
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          if (gamesConsumer.detailedGameModel!
                                  .minimumSystemRequirements !=
                              null)
                            MinimumSystemRequirmentsCard(
                                minimumSystemRequirementsModel: gamesConsumer
                                    .detailedGameModel!
                                    .minimumSystemRequirements!),
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
                                itemCount: gamesConsumer.similarGames.length,
                                itemBuilder: (context, index) => SizedBox(
                                    height: 150,
                                    width: size.width * 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: GameCard(
                                          onLongPress: () {},
                                          gameModel: gamesConsumer
                                              .similarGames[index]),
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
    });
  }
}
