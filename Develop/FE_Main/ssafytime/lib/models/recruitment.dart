// To parse this JSON data, do
//
//     final recruitment = recruitmentFromJson(jsonString);

import 'dart:convert';

Recruitment recruitmentFromJson(String str) => Recruitment.fromJson(json.decode(str));

String recruitmentToJson(Recruitment data) => json.encode(data.toJson());

class Recruitment {
  Recruitment({
    required this.data,
    this.message,
    this.isSuccess,
    this.status,
  });

  List<recruitCompany> data;
  String? message;
  bool? isSuccess;
  String? status;

  factory Recruitment.fromJson(Map<String, dynamic> json) => Recruitment(
    data: json["data"] == null ? [] : List<recruitCompany>.from(json["data"]!.map((x) => recruitCompany.fromJson(x))),
    message: json["message"],
    isSuccess: json["isSuccess"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
    "isSuccess": isSuccess,
    "status": status,
  };
}

class recruitCompany {
  recruitCompany({
    this.date,
    this.company,
    this.job,
    this.link,
  });

  String? date;
  String? company;
  String? job;
  String? link;

  factory recruitCompany.fromJson(Map<String, dynamic> json) => recruitCompany(
    date: json["date"],
    company: json["company"],
    job: json["job"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "startDate": date,
    "company": company,
    "job": job,
    "link": link,
  };
}
