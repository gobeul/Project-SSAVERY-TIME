import 'dart:convert';

class MenuToday {
  MenuToday({
    this.data,
    this.message,
    this.isSuccess,
    this.status,
  });

  List<Datum>? data;
  String? message;
  bool? isSuccess;
  String? status;

  factory MenuToday.fromRawJson(String str) =>
      MenuToday.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MenuToday.fromJson(Map<String, dynamic> json) => MenuToday(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
        isSuccess: json["isSuccess"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "isSuccess": isSuccess,
        "status": status,
      };
}

class Datum {
  Datum({
    this.region,
    this.course,
    this.mainMenu,
    this.sideMenu,
    this.cho,
    this.kcal,
    this.fat,
    this.protein,
    this.sodium,
    this.imageUrl,
  });

  int? region;
  String? course;
  String? mainMenu;
  List<String>? sideMenu;
  int? cho;
  int? kcal;
  int? fat;
  int? protein;
  int? sodium;
  String? imageUrl;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        region: json["region"],
        course: json["course"],
        mainMenu: json["mainMenu"],
        sideMenu: json["sideMenu"] == null
            ? []
            : List<String>.from(json["sideMenu"]!.map((x) => x)),
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
        "sideMenu":
            sideMenu == null ? [] : List<dynamic>.from(sideMenu!.map((x) => x)),
        "cho": cho,
        "kcal": kcal,
        "fat": fat,
        "protein": protein,
        "sodium": sodium,
        "imageUrl": imageUrl,
      };
}
