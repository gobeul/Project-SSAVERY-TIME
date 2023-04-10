import 'dart:convert';

List<SurveyResult> surveyResultFromJson(String str) => List<SurveyResult>.from(
    json.decode(str).map((x) => SurveyResult.fromJson(x)));

String surveyResultToJson(List<SurveyResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SurveyResult {
  SurveyResult({
    required this.questionId,
    required this.response,
  });

  int questionId;
  String response;

  factory SurveyResult.fromJson(Map<String, dynamic> json) => SurveyResult(
        questionId: json["questionId"],
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "response": response,
      };
}
