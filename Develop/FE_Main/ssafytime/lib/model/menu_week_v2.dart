// To parse this JSON data, do
//
//     final menuWeekV2 = menuWeekV2FromJson(jsonString);

import 'dart:convert';

MenuWeekV2 menuWeekV2FromJson(String str) => MenuWeekV2.fromJson(json.decode(str));

String menuWeekV2ToJson(MenuWeekV2 data) => json.encode(data.toJson());

class MenuWeekV2 {
  MenuWeekV2({
    required this.id,
    required this.mainMenu,
    required this.sideMenu,
    required this.kcal,
    required this.imageUrl,
  });

  int id;
  String mainMenu;
  List<String> sideMenu;
  int kcal;
  String imageUrl;

  factory MenuWeekV2.fromJson(Map<String, dynamic> json) => MenuWeekV2(
    id: json["id"],
    mainMenu: json["mainMenu"],
    sideMenu: List<String>.from(json["sideMenu"].map((x) => x)),
    kcal: json["kcal"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mainMenu": mainMenu,
    "sideMenu": List<dynamic>.from(sideMenu.map((x) => x)),
    "kcal": kcal,
    "imageUrl": imageUrl,
  };
}
