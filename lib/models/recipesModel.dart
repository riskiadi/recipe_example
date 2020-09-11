// To parse this JSON data, do
//
//     final recipesModel = recipesModelFromJson(jsonString);

import 'dart:convert';

List<RecipesModel> recipesModelFromJson(String str) => List<RecipesModel>.from(json.decode(str).map((x) => RecipesModel.fromJson(x)));

String recipesModelToJson(List<RecipesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecipesModel {
  RecipesModel({
    this.info,
    this.recipe,
  });

  final Info info;
  final Recipe recipe;

  factory RecipesModel.fromJson(Map<String, dynamic> json) => RecipesModel(
    info: Info.fromJson(json["info"]),
    recipe: Recipe.fromJson(json["recipe"]),
  );

  Map<String, dynamic> toJson() => {
    "info": info.toJson(),
    "recipe": recipe.toJson(),
  };
}

class Info {
  Info({
    this.clap,
    this.creatorEmail,
    this.creatorUsername,
    this.creatorId,
  });

  final String clap;
  final String creatorEmail;
  final String creatorUsername;
  final String creatorId;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    clap: json["clap"],
    creatorEmail: json["creatorEmail"],
    creatorUsername: json["creatorUsername"],
    creatorId: json["creatorId"],
  );

  Map<String, dynamic> toJson() => {
    "clap": clap,
    "creatorEmail": creatorEmail,
    "creatorUsername": creatorUsername,
    "creatorId": creatorId,
  };
}

class Recipe {
  Recipe({
    this.id,
    this.image,
    this.title,
    this.about,
    this.ingredient,
    this.step,
  });

  final String id;
  final String image;
  final String title;
  final String about;
  final String ingredient;
  final String step;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json["id"],
    image: json["image"],
    title: json["title"],
    about: json["about"],
    ingredient: json["ingredient"],
    step: json["step"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "title": title,
    "about": about,
    "ingredient": ingredient,
    "step": step,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
