import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:ssafytime/model/home_menu.dart';
import 'package:ssafytime/model/home_schedule.dart';
import 'package:ssafytime/services/auth_service.dart';

class HomeTimeController extends GetxController {
  late var timer;

  static Map table = {
    0: {'category': '', 'color': 0xff000000}, // 데이터 없음 무제
    1: {'category': '알고리즘', 'color': 0xff0082A1},
    2: {'category': '코딩과정', 'color': 0xff686ADB},
    3: {'category': '프로젝트', 'color': 0xffDE3730},
    4: {'category': '기타', 'color': 0xff0079D1},
  };

  static Map studyPlace = {
    0: '온라인',
    1: '오프라인',
    2: '' // 데이터 없음 or 일과 종료
  };

  DateTime currentTime = DateTime.now(); // 디바이스 시간
  RxInt hour = 0.obs; // 현재 시간 (시)
  int min = 0; // 현재 시간 (분)
  int scheduleHour = 0; // 시간표 시간(시작 시간)
  int scheduleHourEnd = 0; // 시간표 시간(끝나는 시간)
  int totalTime = 0; // 전제 시간
  HomeSchedule nowSchedule = HomeSchedule(); // 현재 시간표
  int nextTime = 0; // 50 분에 다음꺼 조회하기 위한 api 파라미터
  int trackCode = AuthService.to.user.value.trackCode ?? 0;
  int regionCode = AuthService.to.user.value.regionCode ?? 0;

  HomeMenu todayMenu = HomeMenu(); // 오늘 메뉴

  // getx 변수
  RxBool isClassTime = true.obs; // 지금 시간이 시간표상 수업중인 시간인가, 55분부터 59분까지 false
  RxDouble percent = 0.0.obs; // 현재 시간 퍼센트
  RxInt color = 0xff000000.obs; // 색상
  RxString category = ''.obs; // 카테고리
  RxString onoff = ''.obs; // 온라인? 오프라인?
  RxString title = ''.obs; //
  RxString subTitle = ''.obs; //
  RxString classTime = ''.obs; // 수업 시간 표시용, 스트링

  RxBool isLunch = false.obs; // 점심시간에 상태관리로 점심메뉴를 띄우기 위해 둔 값

  @override
  void onInit() {
    super.onInit();
    setInitailTime();

    // 컨트롤러 생성 후 1분마다 반복
    timer = new Timer.periodic(Duration(minutes: 1), (timer) {
      currentTime = DateTime.now(); //
      hour.value = currentTime.hour; // 현재 시간 갱신
      min = currentTime.minute;
      if (min >= 55) {
        // 55분 ~ 59 분에는 nextTime 에 11을 줘서 다음 시간의 시간표를 불러오도록 함
        nextTime = 11;
      } else {
        nextTime = 0;
      }
      fetchHomeSchedule(trackCode, nextTime);
      getLunchTime(); // 점심시간 확인
    });
    fetchTodayMenu(regionCode); // 오늘 메뉴 호출 오늘 하루 변하지 않으므로 한번만 호출
    fetchHomeSchedule(trackCode, nextTime);
  }

  // 현재 시간표 요청, trackCode : 파이썬 자바 등의 트랙 코드, nextTime : 몇 분뒤의 시간표를 호출할 것인지
  Future fetchHomeSchedule(int trackCode, int nextTime) async {
    var res = await http.get(Uri.parse(
        "http://i8a602.p.ssafy.io:9090/schedule/now?track_code=${trackCode}&interval=${nextTime}"));
    var data = json.decode(res.body);

    if (res.statusCode != 200) {
      // 데이터 받기 실패시
      // api 오류 시
      nowSchedule =
          HomeSchedule(data: Data(title: '서버 오류', subTitle: '서버 점검 중 입니다.'));
    } else {
      nowSchedule = HomeSchedule.fromJson(data); // 지금 시간의 시간표
    }

    scheduleHour = nowSchedule.data!.startTime; //시간표의 시작 시간
    scheduleHourEnd = nowSchedule.data!.endTime; // 시간표의 종료 시간
    totalTime = nowSchedule.data!.totalTime; // 종료 시간 - 시작 시간

    //현재 시간이 시간표 시간 값 사이에 있다면 true
    isClassTime.value =
        (hour.value >= scheduleHour && hour.value < scheduleHourEnd)
            ? true
            : false;
    percent.value = getPercent(min); // 프로그래스 바에 쓰일 퍼센트 값 구하기
    color.value = table[nowSchedule.data!.category]['color'];
    category.value = table[nowSchedule.data!.category]['category'];
    onoff.value = studyPlace[nowSchedule.data!.onOff];
    title.value = nowSchedule.data!.title;
    subTitle.value = nowSchedule.data!.subTitle;
    classTime.value = getClassTime(scheduleHour, scheduleHourEnd);
  }

  // 퍼센트 얻기
  double getPercent(int min) {
    if (isClassTime.value == false) {
      // 수업중이 아니라면 프로그래스가 안쓰임
      return 0.0;
    }

    int H = (hour.value - scheduleHour) * 60; // 시간을 분으로 환산해서 비율 계산
    return (H + min) / (totalTime * 60);
  }

  // 수업시간 나타낼 문자열 만들기 (12, 15) -> 12:00 ~ 15:00
  String getClassTime(int startTime, int endTime) {
    String start = startTime < 10 ? '0${startTime}' : '${startTime}';
    String end = endTime < 10 ? '0${endTime}' : '${endTime}';
    return '${start}:00 ~ ${end}:00';
  }

  // 유저 지역의 오늘 식당 메뉴 요청
  Future fetchTodayMenu(int regionCode) async {
    var res = await http.get(Uri.parse(
        'http://i8a602.p.ssafy.io:9090/menu/today?region=${regionCode}'));
    var data = json.decode(res.body);

    if (res.statusCode == 200) {
      todayMenu = HomeMenu.fromJson(data);
    } else {
      todayMenu = HomeMenu(); // 데이처를 받지 못한다면 미리 설정한 디폴트 값으로 만든다.
    }
  }

  // 현재 시간 갱신용 함수
  Future setInitailTime() async {
    currentTime = await DateTime.now();
    hour.value = currentTime.hour; // 현재 시간 갱신
    min = currentTime.minute;
    if (min >= 55) {
      nextTime = 11;
    } else {
      nextTime = 0;
    }
  }

  // 점심시간 설정 및 지금 점심시간인지 구하기
  void getLunchTime() {
    int timer = hour.value * 100 + min;
    if (1150 <= timer && timer <= 1300) {
      // (1150 <= timer && timer <= 1300) -> 11:50 ~ 13:00 까지 점심시간으로 두겠다는 뜻
      isLunch.value = true;
    } else {
      isLunch.value = false;
    }
  }
}
