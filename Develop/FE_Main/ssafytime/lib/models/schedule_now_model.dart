import 'dart:convert';

class ScheduleNow {
  ScheduleNow({
    this.data,
    this.message,
    this.isSuccess,
    this.status,
  });

  Data? data;
  String? message;
  bool? isSuccess;
  String? status;

  factory ScheduleNow.fromRawJson(String str) =>
      ScheduleNow.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleNow.fromJson(Map<String, dynamic> json) => ScheduleNow(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
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
    this.date,
    this.startTime,
    this.endTime,
    this.onOff,
    this.title,
    this.subTitle,
    this.category,
    this.totalTime,
  });

  int? date;
  int? startTime;
  int? endTime;
  int? onOff;
  String? title;
  String? subTitle;
  int? category;
  int? totalTime;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
