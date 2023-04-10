// To parse this JSON data, do
//
//     final myCouncelor = myCouncelorFromJson(jsonString);

import 'dart:convert';

MyCouncelor myCouncelorFromJson(String str) => MyCouncelor.fromJson(json.decode(str));

String myCouncelorToJson(MyCouncelor data) => json.encode(data.toJson());

class MyCouncelor {
  MyCouncelor({
    this.isAdmin,
    this.userName,
    this.userIdx,
    this.userImg,
  });

  int? isAdmin;
  String? userName;
  int? userIdx;
  String? userImg;

  factory MyCouncelor.fromJson(Map<String, dynamic> json) => MyCouncelor(
    isAdmin: json["is_admin"],
    userName: json["user_name"],
    userIdx: json["user_idx"],
    userImg: json["user_img"],
  );

  Map<String, dynamic> toJson() => {
    "is_admin": isAdmin,
    "user_name": userName,
    "user_idx": userIdx,
    "user_img": userImg,
  };
}
