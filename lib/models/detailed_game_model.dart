import 'dart:convert';

class DetailedGameModel {
  int id;
  String title;
  String thumbnail;
  String status;
  String shortDescription;
  String description;
  String gameUrl;
  String genre;
  String platform;
  String publisher;
  String developer;
  String releaseDate;
  String freetogameProfileUrl;
  MinimumSystemRequirementsModel? minimumSystemRequirements;
  List<ScreenshotModel> screenshots;

  DetailedGameModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.status,
    required this.shortDescription,
    required this.description,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.freetogameProfileUrl,
    this.minimumSystemRequirements,
    required this.screenshots,
  });

  factory DetailedGameModel.fromRawJson(String str) =>
      DetailedGameModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailedGameModel.fromJson(Map<String, dynamic> json) =>
      DetailedGameModel(
        id: json["id"],
        title: json["title"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        shortDescription: json["short_description"],
        description: json["description"],
        gameUrl: json["game_url"],
        genre: json["genre"],
        platform: json["platform"],
        publisher: json["publisher"],
        developer: json["developer"],
        releaseDate: json["release_date"],
        freetogameProfileUrl: json["freetogame_profile_url"],
        minimumSystemRequirements:
            json.containsKey("minimum_system_requirements") &&
                    !(!json['platform']
                            .toString()
                            .toUpperCase()
                            .contains("Web".toUpperCase()) &&
                        !json['platform']
                            .toString()
                            .toUpperCase()
                            .contains("Windows".toUpperCase()))
                ? MinimumSystemRequirementsModel.fromJson(
                    json["minimum_system_requirements"])
                : null,
        screenshots: List<ScreenshotModel>.from(
            json["screenshots"].map((x) => ScreenshotModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "status": status,
        "short_description": shortDescription,
        "description": description,
        "game_url": gameUrl,
        "genre": genre,
        "platform": platform,
        "publisher": publisher,
        "developer": developer,
        "release_date": releaseDate,
        "freetogame_profile_url": freetogameProfileUrl,
        "minimum_system_requirements": minimumSystemRequirements!.toJson(),
        "screenshots": List<dynamic>.from(screenshots.map((x) => x.toJson())),
      };
}

class MinimumSystemRequirementsModel {
  String? os;
  String processor;
  String memory;
  String graphics;
  String storage;

  MinimumSystemRequirementsModel({
    this.os,
    required this.processor,
    required this.memory,
    required this.graphics,
    required this.storage,
  });

  factory MinimumSystemRequirementsModel.fromRawJson(String str) =>
      MinimumSystemRequirementsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MinimumSystemRequirementsModel.fromJson(Map<String, dynamic> json) =>
      MinimumSystemRequirementsModel(
        os: json["os"],
        processor: json["processor"],
        memory: json["memory"],
        graphics: json["graphics"],
        storage: json["storage"],
      );

  Map<String, dynamic> toJson() => {
        "os": os,
        "processor": processor,
        "memory": memory,
        "graphics": graphics,
        "storage": storage,
      };
}

class ScreenshotModel {
  int id;
  String image;

  ScreenshotModel({
    required this.id,
    required this.image,
  });

  factory ScreenshotModel.fromRawJson(String str) =>
      ScreenshotModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScreenshotModel.fromJson(Map<String, dynamic> json) =>
      ScreenshotModel(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
