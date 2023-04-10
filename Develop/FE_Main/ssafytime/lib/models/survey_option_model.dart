import 'dart:convert';

class SurveyOption {
  SurveyOption({
    required this.questionIdx,
    required this.questionContent,
    required this.optionList,
  });

  int questionIdx;
  String questionContent;
  List<OptionList> optionList;

  factory SurveyOption.fromRawJson(String str) =>
      SurveyOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SurveyOption.fromJson(Map<String, dynamic> json) => SurveyOption(
        questionIdx: json["id"],
        questionContent: json["questionContent"],
        optionList: List<OptionList>.from(
            json["optionList"].map((x) => OptionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": questionIdx,
        "questionContent": questionContent,
        "optionList": List<dynamic>.from(optionList.map((x) => x.toJson())),
      };
}

class OptionList {
  OptionList({
    required this.id,
    required this.optionContent,
    required this.optionIntensity,
  });

  int id;
  String optionContent;
  int optionIntensity;

  factory OptionList.fromRawJson(String str) =>
      OptionList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OptionList.fromJson(Map<String, dynamic> json) => OptionList(
        id: json["id"],
        optionContent: json["optionContent"],
        optionIntensity: json["optionIntensity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "optionContent": optionContent,
        "optionIntensity": optionIntensity,
      };
}
