import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ssafytime/models/noti_default_state.dart';

class UserStateRepo {
  UserStateRepo({this.token}) {
    header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token}"
    };
  }
  final String? token;
  final String baseUrl = "http://i8a602.p.ssafy.io:9090";
  var header;

  Future<UserDefaultState?> fetchDefaultState(int? userIdx) async {
    var res = await http.get(Uri.parse("${baseUrl}/user/alarm/${userIdx}"),
        headers: header);
    if (res.statusCode == 200) {
      return UserDefaultState.fromJson(json.decode(res.body)['data']);
    }
    return null;
  }

  Future<bool> updateNoticeAlarm(int? userIdx) async {
    var res = await http.patch(
        Uri.parse("${baseUrl}/user/alarm/notice/${userIdx}"),
        headers: header);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateSurveyAlarm(int? userIdx) async {
    var res = await http.patch(
        Uri.parse("${baseUrl}/user/alarm/survey/${userIdx}"),
        headers: header);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateCounselAlarm(int? userIdx) async {
    var res = await http.patch(
        Uri.parse("${baseUrl}/user/alarm/consulting/${userIdx}"),
        headers: header);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
