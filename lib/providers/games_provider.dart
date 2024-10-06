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
  List<GameModel> similarGames = [];

  Future<void> fetchGames(String platform) async {
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

  Future<void> fetchGameById(String id) async {
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

  Future<void> getGamesByCategory(String category) async {
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

  Future<List<GameModel>> getFavoriteGames() async {
    setBusy(true);

    List<GameModel> tgmList = [];
    if (FirebaseAuth.instance.currentUser != null) {
      var uuid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection("favorite_games")
          .where("uid", isEqualTo: uuid)
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

  // Add game to favorites (requires logged in user)
  Future<bool> addToFavorite(GameModel gameModel) async {
    setBusy(true);

    if (FirebaseAuth.instance.currentUser == null) {
      return false; // User not logged in
    }

    final ref = FirebaseFirestore.instance.collection("favorite_games");
    final existing = await ref
        .where("id", isEqualTo: gameModel.id)
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    try {
      if (existing.docs.isEmpty) {
        final jsonGame = gameModel.toJson();
        jsonGame["uid"] = FirebaseAuth.instance.currentUser!.uid;
        await ref.add(jsonGame);
        return true;
      } else {
        return false; // Already favorited
      }
    } catch (error) {
      // Handle errors here (e.g., print error message)
      if (kDebugMode) {
        print("ADD ERROE IS : $error");
      }
      return false;
    } finally {
      setBusy(false);
    }
  }

  // Delete game from favorites (requires logged in user)
  Future<bool> deleteFromFavorite(GameModel gameModel) async {
    setBusy(true);

    if (FirebaseAuth.instance.currentUser == null) {
      if (kDebugMode) {
        print("User not logged in ${FirebaseAuth.instance.currentUser!.uid}");
      }
      return false; // User not logged in
    }

    final ref = FirebaseFirestore.instance.collection("favorite_games");
    final existing = await ref
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    try {
      if (existing.docs.isNotEmpty) {
        await ref.doc(existing.docs.first.id).delete();
        if (kDebugMode) {
          print("DELETED");
        }
        getFavoriteGames();
        return true;
      } else {
        if (kDebugMode) {
          print("NOT FOUND");
        }
        return false; // Not found
      }
    } catch (error) {
      // Handle errors here (e.g., print error message)
      if (kDebugMode) {
        print("DELETE ERROE IS : $error");
      }
      return false;
    } finally {
      if (kDebugMode) {
        print("FINALLY");
      }
      setBusy(false);
    }
  }
}
