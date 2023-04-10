import 'dart:convert';

class UserCustomAlarm {
  UserCustomAlarm({
    required this.title,
    required this.repeatDate,
    required this.time,
    required this.isOn,
    required this.dateSelected,
  });

  String title;
  List<DateTime> repeatDate;
  DateTime time;
  bool isOn;
  List<String> dateSelected;

  factory UserCustomAlarm.fromRawJson(String str) =>
      UserCustomAlarm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserCustomAlarm.fromJson(Map<String, dynamic> json) =>
      UserCustomAlarm(
        title: json["title"],
        repeatDate: List<DateTime>.from(
            json["repeatDate"].map((x) => DateTime.parse(x))),
        time: DateTime.parse(json["time"]),
        isOn: json["isOn"],
        dateSelected: List<String>.from(json["dateSelected"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "repeatDate":
            List<dynamic>.from(repeatDate.map((x) => x.toIso8601String())),
        "time": time.toIso8601String(),
        "isOn": isOn,
        "dateSelected": List<dynamic>.from(dateSelected.map((x) => x)),
      };
}
