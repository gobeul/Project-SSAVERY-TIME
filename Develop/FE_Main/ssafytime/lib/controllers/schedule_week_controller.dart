import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ssafytime/services/auth_service.dart';
import 'dart:convert';
import '../model/schedule_week.dart';

// 주간 시간표 컨트롤러 구조는 주간 식단표 컨트롤러하고 같다.
class SchedulePickDayController extends GetxController {
  RxInt myPick = 9.obs; // 월 ~ 금
  List dayofweek = [0, 0, 0, 0, 0];
  DateTime today = DateTime.now();

  ScheduleWeek weekSchedule = ScheduleWeek();
  RxList<Datum> todaySchedule = <Datum>[].obs; // 내가 선택한 날짜의 시간표
  List<Datum> nullSchedule = [Datum()];

  int? trackCode = AuthService.to.user.value.trackCode ?? 0;


  @override
  void onInit() async{
    super.onInit();

    await fetchScheduleWeek();

    for (int i = 0; i < 5; i++) {
      DateTime tmp = today.subtract(Duration(days: today.weekday - (i + 1)));
      print('tmp.day : ${tmp.day}, today.day : ${today.day}');
      dayofweek[i] = tmp.day;
    }
    selectDay(0); // 주말의 경우 다음 월요일꺼 보여주기
    for (int i = 0; i < 5; i++) {
      if (today.day == dayofweek[i]) {
        myPick.value = i;
        selectDay(i);
      }
    }
  }


  Future fetchScheduleWeek() async{

    var res = await http.get(Uri.parse("http://i8a602.p.ssafy.io:9090/schedule/week?track_code=${trackCode}"));
    var data = json.decode(res.body);

    if (res.statusCode != 200) { // 데이터 받지 못했을 경우
      weekSchedule = ScheduleWeek(
        data: {
          '0' : [],
          '1' : [],
          '2' : [],
          '3' : [],
          '4' : [],
        }
      );

    } else {
      weekSchedule = ScheduleWeek.fromJson(data);
    }
  }

  void selectDay(int idx) {
    myPick.value = idx;

    // today 갱신
    todaySchedule.clear();
    for (int i=0; i < weekSchedule.data!['${idx}']!.length; i++) {
      todaySchedule.add(weekSchedule.data!['${idx}']![i]);
    }

  }
}