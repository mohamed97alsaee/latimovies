import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:latimovies/models/detailed_game_model.dart';
import 'package:latimovies/models/game_model.dart';
import 'package:latimovies/providers/base_provider.dart';
import 'package:latimovies/services/api.dart';

class GamesProvider extends BaseProvider {
  Api api = Api();

  List<GameModel> games = [];
  List<GameModel> favGames = [];

  fetchGames(String platform) async {
    setBusy(true);

    games.clear();
    final response = await api
        .get("https://www.freetogame.com/api/games?platform=$platform");
    // await http.get(
    //     Uri.parse("https://www.freetogame.com/api/games?platform=$platform"));

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      games =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      setBusy(false);
    }
  }

// -------------------------- Detailed Game --------------------------
  DetailedGameModel? detailedGameModel;

  fetchGameById(String id) async {
    setBusy(true);

    // games.clear();
    final response =
        await api.get("https://www.freetogame.com/api/game?id=$id");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      detailedGameModel = DetailedGameModel.fromJson(decodedData);
      getGamesByCategory(detailedGameModel!.genre);

      setBusy(false);
    }
  }

// -------------------------- Similar Games --------------------------

  List<GameModel> similarGames = [];
  getGamesByCategory(String category) async {
    setBusy(true);

    similarGames.clear();
    final response = await api
        .get("https://www.freetogame.com/api/games?category=$category");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      similarGames =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      setBusy(false);
    }
    setBusy(true);
  }

  Future<bool> addToFavorite(GameModel gameModel) async {
    setBusy(true);
    if (kDebugMode) {
      print("FUNCTION : addToFavorite : ${gameModel.toJson()}");
    }
    bool added = false;
    await getFavoriteGames().then((fetchedFavoriteGame) {
      bool isExist = false;
      for (var item in fetchedFavoriteGame) {
        if (item.id == gameModel.id) {
          isExist = true;
          break;
        }
      }

      if (!isExist) {
        FirebaseFirestore.instance
            .collection("favorite_games")
            .add(gameModel.toJson());
        added = true;
      } else {
        added = false;
      }
    });
    setBusy(false);

    return added;
  }

  Future<List<GameModel>> getFavoriteGames() async {
    setBusy(true);

    List<GameModel> tgmList = [];
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("favorite_games")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((data) {
        if (data.docs.isNotEmpty) {
          tgmList = List<GameModel>.from(
              data.docs.map((e) => GameModel.fromJson(e.data()))).toList();
        }
      });
    }

    if (kDebugMode) {
      print("FAV GAMES LENGTH : ${tgmList.length}");
    }
    favGames = tgmList;

    setBusy(false);

    return tgmList;
  }

  deteleFromFavorite(GameModel gameModel) async {
    // setBusy(true);
    // bool deleted = false;
    // if (FirebaseAuth.instance.currentUser != null) {
    //   await FirebaseFirestore.instance
    //       .collection("favorite_games")
    //       .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //       .where("id", isEqualTo: gameModel.id)
    //       .get()
    //       .then((data) async {
    //     if (data.docs.isNotEmpty) {
    //       if (kDebugMode) {
    //         print("DOC UID FROM DELETE ${data.docs.first.id.toString()}");
    //       }
    //       await FirebaseFirestore.instance
    //           .collection("favorite_games")
    //           .doc(data.docs.last.id)
    //           .delete()
    //           .then((d) {
    //         getFavoriteGames();
    //       });

    //       deleted = true;
    //     } else {
    //       deleted = false;
    //     }
    //   });
    // }
    // setBusy(false);
    // return deleted;
  }
}
