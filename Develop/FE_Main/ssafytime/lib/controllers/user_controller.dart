import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ssafytime/model/councel_detail.dart';
import 'package:ssafytime/models/attendance_model.dart';
import 'package:ssafytime/models/recruitment.dart';
import 'package:ssafytime/models/survey_model.dart';
import 'package:ssafytime/models/user_atten_model.dart';
import 'package:ssafytime/models/user_model.dart';
import 'package:ssafytime/repositories/home_repository.dart';
import 'package:ssafytime/repositories/user_repository.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/notification_infomation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

/**
 * home screen의 유저 관련 항목 관리 컨트롤러
 */
class UserController extends GetxController {
  static UserController get to => Get.find();

  List<String> attenCategory = [
    "absentR",
    "absentO",
    "attenT",
    "attenN",
    "lateR",
    "lateO"
  ];

  final atten = AttenModel().obs;

  final userAtten = UserAtten().obs;

  final carouselItemList = <dynamic>[].obs;
  final carouselItemListWidget = <Widget>[].obs;

  final dateF = new DateFormat("yy-MM-dd");
  final timeF = new DateFormat("yy-MM-dd HH:mm");

  UserRepo userApi = UserRepo(token: AuthService.to.accessToken.value);
  HomeRepo homeApi = HomeRepo(token: AuthService.to.accessToken.value);

  var oncommingCouncel = CouncelDetail().obs; // 기한이 임박한 상담
  int councelTime = 999999999999;

  Recruitment recruitmentList = Recruitment(data: []);
  RxInt recruitCnt = 0.obs;

  @override
  void onInit() async {
    fetchRecruitmentInfo();
    super.onInit();
  }

  @override
  void onReady() async {
    await initFetch();
    super.onReady();
  }

  Future<void> initFetch() async {
    carouselItemList.clear();
    carouselItemListWidget.clear();
    await fetchUser();
    await fetchAttence();
    await fetchNotice();
    await fetchHomeSurvey();
    await fetchOncommingCouncel();
    setCaroselItemList();
    setAtten();
  }

  Future<void> fetchUser() async {
    User? userInfo = await userApi.fetchUserInfo();
    log("${userInfo?.userEmail}");
    if (userInfo != null) {
      var fcmToken = await userApi.fetchFcmToken();
      bool res = await userApi.updateFcmToken(fcmToken);
      if (res) {
        AuthService.to.user(userInfo);
      }
    }
  }

  Future<void> fetchAttence() async {
    atten(await homeApi.fetchAttendence());
  }

  Future<void> fetchNotice() async {
    var data = await homeApi.fetchNotice();
    if (data != null) {
      carouselItemList.add(data);
    }
  }

  Future<void> fetchHomeSurvey() async {
    List<Survey>? data = await homeApi.fetchHomeSurvey();
    var result = data?[0];

    if (result != null) {
      carouselItemList.add(result);
    }
  }

  void setAtten() {
    Map<String, int> attenRaw = {};
    atten.value.attendance?.forEach(
        (e) => {attenRaw[attenCategory[e.category ?? 0]] = e.count ?? 0});

    userAtten(UserAtten(
      absentO: attenRaw['absentO'] ?? 0,
      absentR: attenRaw['absentR'] ?? 0,
      lateR: attenRaw['lateR'] ?? 0,
      lateO: attenRaw['lateO'] ?? 0,
      attenN: attenRaw['attenN'] ?? 0,
      attenT: attenRaw['attenT'] ?? 0,
    ));
  }

  void setCaroselItemList() {
    carouselItemListWidget.clear();
    if (carouselItemList.length > 0) {
      carouselItemList.forEach((element) {
        switch (element.notiType) {
          case 1:
            carouselItemListWidget.add(CNI(
                opacity: 1,
                myIcon: FontAwesomeIcons.bullhorn,
                iconColor: 0xffFF5449,
                title: element.title,
                detail: Text(dateF.format(element.createDateTime)),
                isComplete: ""));
            break;
          case 2:
            carouselItemListWidget.add(CNI(
                opacity: _setSurveyOpacity(element.status),
                myIcon: FontAwesomeIcons.pen,
                iconColor: 0xff0079D1,
                title: element.title,
                detail: Text(
                    "${timeF.format(element.startDate)} ~ ${timeF.format(element.endDate)}"),
                isComplete: _setSurveyIsComplete(element.status)));
            break;
          case 3:
            carouselItemListWidget.add(CNI(
                opacity: _setCounselOpacity(element.state),
                myIcon: FontAwesomeIcons.userGroup,
                iconColor: 0xff686ADB,
                title: element.title,
                detail:
                    Text("${dateF.format(element.rezDate)} ${element.rezTime}"),
                isComplete: _setCounselIsComplete(element.state)));
            break;
        }
      });
    } else {
      carouselItemListWidget.add(CNI(
          opacity: 1,
          myIcon: FontAwesomeIcons.spinner,
          iconColor: 0xff808080,
          title: "로딩 중",
          detail: Text("로딩 중"),
          isComplete: ""));
    }
    log("캐로셀 길이 ${carouselItemList.length}");
    log("캐로셀위젯 길이 ${carouselItemListWidget.length}");
  }

  // 승인된 상담중에 곧 다가오는 상담 가져오기
  Future fetchOncommingCouncel() async {
    int? userId = AuthService.to.user.value.userIdx;
    int? isAdmin = AuthService.to.user.value.isAdmin;

    if (userId == null || isAdmin == null) {
      return;
    }

    var res = await http.get(
        Uri.parse("http://i8a602.p.ssafy.io:9090/meet/${userId}/${isAdmin}"));
    var data = json.decode(res.body);

    var date = DateTime.now();
    int current = date.year * 100000000 +
        date.month * 1000000 +
        date.day * 10000 +
        date.hour * 100 +
        date.minute;

    for (int i = 0; i < data.length; i++) {
      final obj = CouncelDetail.fromJson(data[i]).obs;
      final int Time =
          calculatorTimeOfClass(obj.value.rezDate, obj.value.rezTime).round();
      if (obj.value.state == 2 && Time < councelTime) {
        councelTime = Time;
        oncommingCouncel = obj;
      }
    }

    if (oncommingCouncel.value.createDateTime != null) {
      carouselItemList.add(oncommingCouncel.value);
    }
  }

  double calculatorTimeOfClass(DateTime? rezDate, double rezTime) {
    if (rezDate == null) {
      return 999999999999;
    }
    String year = rezDate.year.toString();
    String mon = rezDate.month.toString();
    String day = rezDate.day.toString();
    mon.length == 1 ? mon = '0' + mon : null;
    day.length == 1 ? day = '0' + day : null;
    String tmpDate = year + mon + day;
    double dateValue = double.parse(tmpDate);

    // 13.0 -> 1300 으로 , 14.5 -> 1430 으로
    double rezHour = rezTime;
    double rezMin = rezHour % 1;
    rezHour -= rezMin;
    double rezHourToMin = rezMin * 60;
    double timeFinal = rezHour * 100 + rezHourToMin;

    return dateValue * 10000 + timeFinal;
  }

  Future fetchRecruitmentInfo() async {
    var res = await http.get(Uri.parse("http://i8a602.p.ssafy.io:9090/job"));
    var data = json.decode(res.body);

    recruitmentList = Recruitment.fromJson(data);
    recruitCnt.value = recruitmentList.data.length;
  }

  double _setSurveyOpacity(int status) {
    switch (status) {
      case 0:
        return 0.4;
      case 1:
        return 1;
      case 2:
        return 0.6;
      case 3:
        return 0.6;
      default:
        return 1;
    }
  }

  String _setSurveyIsComplete(int status) {
    switch (status) {
      case 0:
        return "예정";
      case 1:
        return "진행";
      case 2:
        return "종료";
      case 3:
        return "완료";
      default:
        return "예정";
    }
  }

  double _setCounselOpacity(int status) {
    switch (status) {
      case 1:
        return 1;
      case 2:
        return 1;
      case 3:
        return 0.6;
      case 4:
        return 0.6;
      default:
        return 1;
    }
  }

  String _setCounselIsComplete(int status) {
    switch (status) {
      case 1:
        return "신청";
      case 2:
        return "승인";
      case 3:
        return "종료";
      case 4:
        return "거절";
      default:
        return "예정";
    }
  }
}
