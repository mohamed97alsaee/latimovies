import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latimovies/helpers/consts.dart';
import 'package:latimovies/main.dart';
import 'package:latimovies/providers/auth_provider.dart';
import 'package:latimovies/providers/games_provider.dart';
import 'package:latimovies/screens/favorite_games_screen.dart';
import 'package:latimovies/widgets/cards/game_card.dart';
import 'package:latimovies/widgets/clickables/main_button.dart';
import 'package:latimovies/widgets/dialogs/add_to_favorite_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nowIndex = 0;
  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).fetchGames("all");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamesProvider>(builder: (context, gamesConsumer, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          Provider.of<GamesProvider>(context, listen: false).getFavoriteGames();
        }),
        drawer: Drawer(
          child: Column(
            children: [
              MainButton(
                  label: "Logout",
                  onPressed: () {
                    Provider.of<AutheticationProvider>(context, listen: false)
                        .logout()
                        .then((logedOut) {
                      if (logedOut) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const ScreenRouter()),
                            (route) => false);
                      }
                    });
                  })
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("GAMER"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const FavoriteGamesScreen()));
                },
                icon: const Icon(Icons.favorite))
          ],
        ),
        body: Center(
            child: GridView.builder(
                itemCount: gamesConsumer.busy ? 6 : gamesConsumer.games.length,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: gamesConsumer.busy
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Shimmer.fromColors(
                                  baseColor: Colors.black12,
                                  highlightColor: Colors.white38,
                                  child: Container(
                                    color: Colors.white,
                                    height: double.infinity,
                                    width: double.infinity,
                                  )),
                            )
                          : GameCard(
                              gameModel: gamesConsumer.games[index],
                              onLongPress: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AddToFavoriteDialog(
                                        gameModel: gamesConsumer.games[index],
                                      );
                                    });
                              },
                            ));
                })),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: redColor,
            selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 12),
            onTap: (currentIndex) {
              setState(() {
                nowIndex = currentIndex;
              });

              Provider.of<GamesProvider>(context, listen: false)
                  .fetchGames(currentIndex == 0
                      ? "all"
                      : currentIndex == 1
                          ? "pc"
                          : "browser");
            },
            currentIndex: nowIndex,
            items: const [
              BottomNavigationBarItem(
                  label: "All", icon: Icon(FontAwesomeIcons.gamepad)),
              BottomNavigationBarItem(
                  label: "PC", icon: Icon(FontAwesomeIcons.computer)),
              BottomNavigationBarItem(
                  label: "WEB", icon: Icon(FontAwesomeIcons.globe)),
            ]),
      );
    });
  }
}
