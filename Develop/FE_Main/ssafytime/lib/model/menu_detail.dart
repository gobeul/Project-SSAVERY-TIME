// To parse this JSON data, do
//
//     final menuDetail = menuDetailFromJson(jsonString);

import 'dart:convert';

MenuDetail menuDetailFromJson(String str) => MenuDetail.fromJson(json.decode(str));

String menuDetailToJson(MenuDetail data) => json.encode(data.toJson());

class MenuDetail {
  MenuDetail({
    required this.region,
    required this.course,
    required this.mainMenu,
    required this.sideMenu,
    required this.cho,
    required this.kcal,
    required this.fat,
    required this.protein,
    required this.sodium,
    required this.imageUrl,
  });

  int region;
  String course;
  String mainMenu;
  List<String> sideMenu;
  int cho;
  int kcal;
  int fat;
  int protein;
  int sodium;
  String imageUrl;

  factory MenuDetail.fromJson(Map<String, dynamic> json) => MenuDetail(
    region: json["region"],
    course: json["course"],
    mainMenu: json["mainMenu"],
    sideMenu: List<String>.from(json["sideMenu"].map((x) => x)),
    cho: json["cho"],
    kcal: json["kcal"],
    fat: json["fat"],
    protein: json["protein"],
    sodium: json["sodium"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "region": region,
    "course": course,
    "mainMenu": mainMenu,
    "sideMenu": List<dynamic>.from(sideMenu.map((x) => x)),
    "cho": cho,
    "kcal": kcal,
    "fat": fat,
    "protein": protein,
    "sodium": sodium,
    "imageUrl": imageUrl,
  };
}
