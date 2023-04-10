// To parse this JSON data, do
//
//     final scheduleWeek = scheduleWeekFromJson(jsonString);

import 'dart:convert';

ScheduleWeek scheduleWeekFromJson(String str) => ScheduleWeek.fromJson(json.decode(str));

String scheduleWeekToJson(ScheduleWeek data) => json.encode(data.toJson());

class ScheduleWeek {
  ScheduleWeek({
    this.data,
    this.message,
    this.isSuccess,
    this.status,
  });

  Map<String, List<Datum>>? data;
  String? message;
  bool? isSuccess;
  String? status;

  factory ScheduleWeek.fromJson(Map<String, dynamic> json) => ScheduleWeek(
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, List<Datum>>(k, List<Datum>.from(v.map((x) => Datum.fromJson(x))))),
    message: json["message"],
    isSuccess: json["isSuccess"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    "message": message,
    "isSuccess": isSuccess,
    "status": status,
  };
}

class Datum {
  Datum({
    this.date = 0,
    this.startTime = 9,
    this.endTime = 18,
    this.onOff = 2,
    this.title = '데이터가 없습니다.',
    this.subTitle = '서버 점검 중..',
    this.category = 0, //  0 == api 오류 or 시간표가 없을떄
    this.totalTime = 9,
  });

  int date;
  int startTime;
  int endTime;
  int onOff;
  String title;
  String subTitle;
  int category;
  int totalTime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    "title": titleValues.reverse[title],
    "subTitle": subTitleValues.reverse[subTitle],
    "category": category,
    "totalTime": totalTime,
  };
}

enum SubTitle { EMPTY }

final subTitleValues = EnumValues({
  "공통 프로젝트": SubTitle.EMPTY
});

enum Title { EMPTY, PJT, LIVE_BACK_END, LIVE_FRONT_END }

final titleValues = EnumValues({
  "취업 특강": Title.EMPTY,
  "[LIVE] Back-End": Title.LIVE_BACK_END,
  " [LIVE] Front-End": Title.LIVE_FRONT_END,
  "팀별 PJT 진행": Title.PJT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}






// // To parse this JSON data, do
// //
// //     final weekSchedule = weekScheduleFromJson(jsonString);
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../model/menu_week.dart';
//
// Map<String, List<Schedule>> scheduleFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, List<Schedule>>(k, List<Schedule>.from(v.map((x) => Schedule.fromJson(x)))));
//
// String scheduleToJson(Map<String, List<Schedule>> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))));
//
// class Schedule {
//   Schedule({
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     required this.onOff,
//     required this.title,
//     required this.subTitle,
//     required this.category,
//     required this.totalTime,
//   });
//
//   int date;
//   int startTime;
//   int endTime;
//   int onOff;
//   String title;
//   String subTitle;
//   int category;
//   int totalTime;
//
//   factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
//     date: json["date"],
//     startTime: json["startTime"],
//     endTime: json["endTime"],
//     onOff: json["onOff"],
//     title: json["title"],
//     subTitle: json["subTitle"],
//     category: json["category"],
//     totalTime: json["totalTime"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "date": date,
//     "startTime": startTime,
//     "endTime": endTime,
//     "onOff": onOff,
//     "title": title,
//     "subTitle": subTitle,
//     "category": category,
//     "totalTime": totalTime,
//   };
// }
//
//
// void testschedule(int trackCode) async {
//
//   var res = await http.get(Uri.parse("http://i8a602.p.ssafy.io:9090/schedule/week?track_code=${trackCode}"));
//   var data = json.decode(res.body);
//
//   final List dataList = data['data'].values.map((x) => x).toList();
//
//   List weekofschedule = [];
//   for (int i=0; i < dataList.length; i++) {
//     List dayofschedule = [];
//     for (int j=0; j < dataList[i].length; j++) {
//       dayofschedule.add(
//           Schedule(
//             date: dataList[i][j]["date"],
//             startTime: dataList[i][j]["startTime"],
//             endTime: dataList[i][j]["endTime"],
//             onOff: dataList[i][j]["onOff"],
//             title: dataList[i][j]["title"],
//             subTitle: dataList[i][j]["subTitle"],
//             category: dataList[i][j]["category"],
//             totalTime: dataList[i][j]["totalTime"],
//           )
//       );
//     }
//     weekofschedule.add(dayofschedule);
//   }
// }