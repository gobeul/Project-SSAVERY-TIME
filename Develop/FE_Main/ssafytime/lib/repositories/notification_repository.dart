import 'package:http/http.dart' as http;
import 'package:ssafytime/model/councel_detail.dart';
import 'package:ssafytime/models/notice_model.dart';
import 'package:ssafytime/models/survey_model.dart';

class NotiRepo {
  NotiRepo({this.token}) {
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token}"
    };
  }

  final String? token;
  var headers;
  String baseUrl = "http://i8a602.p.ssafy.io:9090";

  Future<List<Notice>?> fetchNoticeList() async {
    var res =
        await http.get(Uri.parse("${baseUrl}/notice/all"), headers: headers);

    if (res.statusCode == 200) {
      return NoticeList.fromRawJson(res.body).data;
    }
    return null;
  }

  Future<List<Survey>?> completeSurveyList() async {
    var res = await http.get(Uri.parse("${baseUrl}/surveys/survey/conduct"),
        headers: headers);
    if (res.statusCode == 200) {
      return SurveyList.fromRawJson(res.body).survey;
    }
    return null;
  }

  Future<List<Survey>?> fetchSurveryList() async {
    var res = await http.get(Uri.parse("${baseUrl}/surveys/survey"),
        headers: headers);
    if (res.statusCode == 200) {
      return SurveyList.fromRawJson(res.body).survey;
    }
    return null;
  }

  Future<List<CouncelDetail>?> fetchCounselList(
      int? userIdx, int isAdmin) async {
    var res = await http.get(Uri.parse("${baseUrl}/meet/${userIdx}/${isAdmin}"),
        headers: headers);
    if (res.statusCode == 200) {
      return councelDetailFromJson(res.body);
    }
    return null;
  }
}
