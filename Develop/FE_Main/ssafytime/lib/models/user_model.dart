import 'dart:convert';

class User {
  User({
    this.userIdx,
    this.userName,
    this.userEmail,
    this.classNum,
    this.trackCode,
    this.regionCode,
    this.exp,
    this.mileage,
    this.isAdmin,
    this.userImg,
  });

  int? userIdx;
  String? userName;
  String? userEmail;
  int? classNum;
  int? trackCode;
  int? regionCode;
  int? exp;
  int? mileage;
  dynamic isAdmin;
  String? userImg;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        userIdx: json["id"],
        userName: json["userName"],
        userEmail: json["userEmail"],
        classNum: json["class_num"],
        trackCode: json["trackCode"],
        regionCode: json["regionCode"],
        exp: json["exp"],
        mileage: json["mileage"],
        isAdmin: json["isAdmin"],
        userImg: json["userImg"],
      );

  Map<String, dynamic> toJson() => {
        "id": userIdx,
        "userName": userName,
        "userEmail": userEmail,
        "class_num": classNum,
        "trackCode": trackCode,
        "regionCode": regionCode,
        "exp": exp,
        "mileage": mileage,
        "isAdmin": isAdmin,
        "userImg": userImg,
      };
}
