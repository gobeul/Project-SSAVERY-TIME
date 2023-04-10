import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:ssafytime/models/attendance_model.dart';

import 'package:ssafytime/models/home_menu_model.dart';
import 'package:ssafytime/models/notice_model.dart';
import 'package:ssafytime/models/schedule_now_model.dart';
import 'package:ssafytime/models/survey_model.dart';

class HomeRepo {
  String? token;
  Map<String, String>? headers;
  String baseUrl = "http://i8a602.p.ssafy.io:9090/";

  HomeRepo({this.token}) {
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token}"
    };
  }

  Future<ScheduleNow?> fetchScheduleNow(int? trackCode) async {
    var res = await http.get(
        Uri.parse(baseUrl + "schedule/now?track_code=${trackCode}"),
        headers: headers);
    log("trackCode : ${trackCode}");
    if (res.statusCode == 200) {
      return ScheduleNow.fromRawJson(res.body);
    }
    return null;
  }

  Future<MenuToday?> fetchMenuToday(int? regionCode) async {
    var res = await http.get(
        Uri.parse(baseUrl + "menu/today?region=${regionCode}"),
        headers: headers);
    if (res.statusCode == 200) {
      return MenuToday.fromRawJson(res.body);
    }
    return null;
  }

  Future<AttenModel?> fetchAttendence() async {
    var res = await http.get(Uri.parse(baseUrl + "user/attendance"),
        headers: headers);
    if (res.statusCode == 200) {
      return AttenModel.fromRawJson(res.body);
    }
    return null;
  }

  Future<Notice?> fetchNotice() async {
    var res = await http.get(Uri.parse(baseUrl + "notice"), headers: headers);
    if (res.statusCode == 200) {
      return Notice.fromJson(json.decode(res.body)['data']);
    }
    return null;
  }

  Future<List<Survey>?> fetchHomeSurvey() async {
    var res = await http.get(Uri.parse("${baseUrl}surveys/main/survey"),
        headers: headers);
    log("${res.statusCode}=====================");
    if (res.statusCode == 200) {
      return SurveyList.fromRawJson(res.body).survey;
    }
    return null;
  }
}
