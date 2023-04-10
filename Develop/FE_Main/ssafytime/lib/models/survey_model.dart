import 'dart:convert';

class SurveyList {
  SurveyList({
    this.survey,
  });

  List<Survey>? survey;

  factory SurveyList.fromRawJson(String str) =>
      SurveyList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SurveyList.fromJson(List<dynamic> json) => SurveyList(
        survey: json.length < 0
            ? []
            : List<Survey>.from(json.map((x) => Survey.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "survey": survey == null
            ? []
            : List<dynamic>.from(survey!.map((x) => x.toJson())),
      };
}

class Survey {
  Survey({
    required this.surveyIdx,
    this.title,
    this.status,
    this.category,
    this.startDate,
    this.endDate,
    this.createDateTime,
    this.notiType = 2,
  });

  int surveyIdx;
  String? title;
  int? status;
  int? category;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createDateTime;
  int? notiType;

  factory Survey.fromRawJson(String str) => Survey.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
      surveyIdx: json["id"],
      title: json["title"],
      status: json["status"],
      category: json["category"],
      startDate:
          json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
      endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
      createDateTime:
          json["madeAt"] == null ? null : DateTime.parse(json["madeAt"]));

  Map<String, dynamic> toJson() => {
        "id": surveyIdx,
        "title": title,
        "status": status,
        "category": category,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "madeAt": createDateTime?.toIso8601String(),
      };
}
