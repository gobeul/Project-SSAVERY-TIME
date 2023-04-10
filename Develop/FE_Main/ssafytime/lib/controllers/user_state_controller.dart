import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ssafytime/models/user_custom_alarm.dart';
import 'package:ssafytime/models/noti_default_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssafytime/repositories/user_state_repository.dart';

import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/services/noti_service.dart';


class UserStateController extends GetxController {
  late SharedPreferences pref;
  final defaultAlarms = UserDefaultState(
          noticeAlarm: true, surveyAlarm: true, consultingAlarm: true)
      .obs;
  RxList<UserCustomAlarm> customState = <UserCustomAlarm>[].obs;

  Rxn<DateTime> dateTime = Rxn<DateTime>(DateTime.now());
  RxList<String> dateSelected = <String>[].obs;
  final int? userIdx = AuthService.to.user.value.userIdx;
  final UserStateRepo stateApi =
      UserStateRepo(token: AuthService.to.accessToken.value);


  @override
  void onInit() async {
    initDateSelectItem();
    pref = await SharedPreferences.getInstance();
    await fetchDefaultState();
    await fetchCustomState();
    dateTime.value = DateTime.now();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    saveCustomState();
  }

// 내부 저장소에서 개인 알림 가져오기
  Future<void> fetchCustomState() async {
    final List<String>? customStateItems =
        pref.getStringList("${userIdx}_noti");
    if (customStateItems != null) {
      var item = List<UserCustomAlarm>.from(
          customStateItems.map((e) => UserCustomAlarm.fromRawJson(e)));
      log(customStateItems.toString());
      customState.addAll(item);
    }
  }

// 개인 알림 추가
  void addCustomState(String title) async {
    bool state = true;
    UserCustomAlarm custom = UserCustomAlarm(
        title: title,
        repeatDate: _calcDayOfWeek(),
        time: dateTime.value ?? DateTime.now(),
        isOn: state,
        dateSelected: dateSelected);
    customState.add(custom);
    await NotiService.to
        .addAlarm(title, dateTime.value ?? DateTime.now(), _calcDayOfWeek());
    saveCustomState();
  }

// 개인 알림 삭제
  void removeCustomState(int index) async {
    await NotiService.to.removeAlarm(customState[index].repeatDate);
    customState.removeAt(index);
    saveCustomState();
  }

// 개인 알림 켜기
  void onCustomState(int idx) async {
    await NotiService.to.addAlarm(customState[idx].title, customState[idx].time,
        customState[idx].repeatDate);
    saveCustomState();
  }

// 개인 알림 끄기
  void offCustomState(int idx) async {
    await NotiService.to.removeAlarm(customState[idx].repeatDate);
    saveCustomState();
  }

// 개인 알림 저장
  void saveCustomState() async {
    List<String> saveCustomAlarm = [];
    customState.forEach((e) {
      saveCustomAlarm.add(e.toRawJson());
    });

    log("유저 정보 : ${userIdx}");

    await pref.setStringList("${userIdx}_noti", saveCustomAlarm);
  }

// 서버에서 기본 알림 설정 가져오기
  Future<void> fetchDefaultState() async {
    var data = await stateApi.fetchDefaultState(userIdx);
    if (data != null) {
      defaultAlarms(data);
    }
  }

  Future<void> setDefaultState() async {}

  List<DateTime> _calcDayOfWeek() {
    DateTime _now = new DateTime.now();
    List<DateTime> dayOfWeeks = List<DateTime>.from(dateSelected.map((e) {
      switch (e) {
        case "월":
          return _now.subtract(Duration(days: _now.weekday - 1));
        case "화":
          return _now.subtract(Duration(days: _now.weekday - 2));
        case "수":
          return _now.subtract(Duration(days: _now.weekday - 3));
        case "목":
          return _now.subtract(Duration(days: _now.weekday - 4));
        case "금":
          return _now.subtract(Duration(days: _now.weekday - 5));
        case "토":
          return _now.subtract(Duration(days: _now.weekday - 6));
        case "일":
          return _now.subtract(Duration(days: _now.weekday - 7));
      }
    }));

    return dayOfWeeks;
  }

  void initDateSelectItem() {
    log("onReady");
    dateSelected.clear();
    String todayE = DateFormat.E('ko_KR').format(DateTime.now());
    dateSelected.add(todayE);
  }

  void updateNoticeAlarm(bool value) async {
    defaultAlarms.value.noticeAlarm = value;
    await stateApi.updateNoticeAlarm(userIdx);
  }

  void updateSurveyAlarm(bool value) async {
    defaultAlarms.value.surveyAlarm = value;
    await stateApi.updateSurveyAlarm(userIdx);
  }

  void updateCounselAlarm(bool value) async {
    defaultAlarms.value.consultingAlarm = value;
    await stateApi.updateCounselAlarm(userIdx);
  }

  void checkout() {
    log("${_calcDayOfWeek().toString()}");
    log("${DateTime.now().toIso8601String()}");
  }
}
