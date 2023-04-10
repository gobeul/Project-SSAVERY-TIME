import 'dart:convert';

List<CouncelDetail> councelDetailFromJson(String str) =>
    List<CouncelDetail>.from(
        json.decode(str).map((x) => CouncelDetail.fromJson(x)));

String councelDetailToJson(List<CouncelDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CouncelDetail {
  CouncelDetail({
    this.rezDate,
    this.rezTime = 0.0,
    this.title = '',
    this.category = '',
    this.meetUrl = '',
    this.rezIdx = -1,
    this.reject,
    this.state = 0,
    this.name = '',
    this.sessionId,
    this.createDateTime,
    this.notiType = 3,
    // required double this.exEndTime,
  });

  DateTime? rezDate;
  double rezTime;
  String title;
  String category;
  dynamic meetUrl;
  int rezIdx;
  String? reject;
  int state;
  String name;
  String? sessionId;
  DateTime? createDateTime;
  int? notiType;

  factory CouncelDetail.fromJson(Map<String, dynamic> json) => CouncelDetail(
        rezDate: DateTime.parse(json["rezDate"]),
        rezTime: json["rezTime"]?.toDouble(),
        title: json["title"],
        category: json["category"],
        meetUrl: json["meetUrl"],
        rezIdx: json["rezIdx"],
        reject: json["reject"],
        state: json["state"],
        name: json["name"],
        sessionId: json["sessionId"],
        createDateTime:
            json["subTime"] == null ? null : DateTime.parse(json["subTime"]),
      );

  Map<String, dynamic> toJson() => {
        "rezDate": rezDate == null
            ? '9999-09-09'
            : "${rezDate!.year.toString().padLeft(4, '0')}-${rezDate!.month.toString().padLeft(2, '0')}-${rezDate!.day.toString().padLeft(2, '0')}",
        "rezTime": rezTime,
        "title": title,
        "category": category,
        "meetUrl": meetUrl,
        "rezIdx": rezIdx,
        "reject": reject,
        "state": state,
        "name": name,
        "sessionId": sessionId,
        "subTime": createDateTime?.toIso8601String(),
      };

  double calculatorTimeOfClass(DateTime rezDate, double rezTime) {
    String s = '';
    s = rezDate.year.toString() +
        rezDate.month.toString() +
        rezDate.day.toString();

    // 13.0 -> 1300 으로 , 14.5 -> 1430 으로
    double a = rezTime;
    double b = a % 1;
    a -= b;
    double c = b * 60;
    double d = a * 100 + c;

    return d;
  }
}
