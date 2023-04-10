// To parse this JSON data, do
//
//     final homeMenu = homeMenuFromJson(jsonString);

import 'dart:convert';

HomeMenu homeMenuFromJson(String str) => HomeMenu.fromJson(json.decode(str));

String homeMenuToJson(HomeMenu data) => json.encode(data.toJson());

class HomeMenu {

  HomeMenu({
    this.data,
    this.message,
    this.isSuccess,
    this.status,
  });

  List<Datum>? data;
  String? message;
  bool? isSuccess;
  String? status;

  factory HomeMenu.fromJson(Map<String, dynamic> json) => HomeMenu(
    data: json["data"] == null ? [Datum(), Datum()] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    message: json["message"],
    isSuccess: json["isSuccess"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
    "isSuccess": isSuccess,
    "status": status,
  };
}

class Datum {
  // static String noImage = 'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg';

  Datum({
    this.id = -1,
    this.mainMenu = '서버 점검 중 입니다',
    this.sideMenu = const [],
    this.kcal = 0,
    this.imageUrl = 'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg',
  });

  int id;
  String mainMenu;
  List<String> sideMenu;
  int kcal;
  String imageUrl;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mainMenu: json["mainMenu"],
    sideMenu: json["sideMenu"] == null ? [] : List<String>.from(json["sideMenu"]!.map((x) => x)),
    kcal: json["kcal"],
    imageUrl: json["imageUrl"] == "" ? 'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg' :
      json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mainMenu": mainMenu,
    "sideMenu": sideMenu == null ? [] : List<dynamic>.from(sideMenu!.map((x) => x)),
    "kcal": kcal,
    "imageUrl": imageUrl,
  };
}
