// To parse this JSON data, do
//
//     final homeSchedule = homeScheduleFromJson(jsonString);

import 'dart:convert';

HomeSchedule homeScheduleFromJson(String str) => HomeSchedule.fromJson(json.decode(str));

String homeScheduleToJson(HomeSchedule data) => json.encode(data.toJson());

class HomeSchedule {
  HomeSchedule({
    this.data,
    this.message,
    this.isSuccess,
    this.status,
  });

  Data? data;
  String? message;
  bool? isSuccess;
  String? status;

  factory HomeSchedule.fromJson(Map<String, dynamic> json) => HomeSchedule(
    data: json["data"] == null ? Data() : Data.fromJson(json["data"]),
    message: json["message"],
    isSuccess: json["isSuccess"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
    "isSuccess": isSuccess,
    "status": status,
  };
}

class Data {
  Data({
    this.date = 0,
    this.startTime = 0,
    this.endTime = 0,
    this.onOff = 2, // 2 = 데이터 없음 or 일과 끝남
    this.title = '일과시간 종료',
    this.subTitle = '오늘 고생 많으셨습니다.',
    this.category = 0, // 0 = 데이터 없음 or 일과 끝남
    this.totalTime = 0,
  });

  int date;
  int startTime;
  int endTime;
  int onOff;
  String title;
  String subTitle;
  int category;
  int totalTime;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    date: json["date"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    onOff: json["onOff"],
    title: json["title"],
    subTitle: json["subTitle"],
    category: json["category"],
    totalTime: json["totalTime"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "startTime": startTime,
    "endTime": endTime,
    "onOff": onOff,
    "title": title,
    "subTitle": subTitle,
    "category": category,
    "totalTime": totalTime,
  };
}
