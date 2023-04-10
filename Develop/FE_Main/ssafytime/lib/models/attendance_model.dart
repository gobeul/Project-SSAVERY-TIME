import 'dart:convert';

class AttenModel {
  AttenModel({
    this.attendance,
  });

  List<Attendance>? attendance;

  factory AttenModel.fromRawJson(String str) =>
      AttenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttenModel.fromJson(Map<String, dynamic> json) => AttenModel(
        attendance: json["attendance"] == null
            ? []
            : List<Attendance>.from(
                json["attendance"]!.map((x) => Attendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attendance": attendance == null
            ? []
            : List<dynamic>.from(attendance!.map((x) => x.toJson())),
      };
}

class Attendance {
  Attendance({
    this.category,
    this.count,
  });

  int? category;
  int? count;

  factory Attendance.fromRawJson(String str) =>
      Attendance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        category: json["category"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "count": count,
      };
}
