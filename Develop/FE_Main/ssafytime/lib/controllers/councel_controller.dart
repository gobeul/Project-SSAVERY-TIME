// councel에서 사용하는 컨트롤러 전체
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/controllers/loading_controller.dart';

import '../model/councel_bottom_councelor.dart';
import '../model/councel_detail.dart';

class MyCouncelController extends GetxController {
  static MyCouncelController get to => Get.find();

  int? userID = AuthService.to.user.value.userIdx;
  int? userAdmin = AuthService.to.user.value.isAdmin;
  int? userTrackCode = AuthService.to.user.value.trackCode;
  int? userRegionCode = AuthService.to.user.value.regionCode;
  int? userClassNum = AuthService.to.user.value.classNum;

  List myCouncelList = [].obs; // 내 상담 신청 현황들
  // Rx<DateTime> currentTime = DateTime.now().add(Duration(hours: 9)).obs;
  Rx<DateTime> currentTime = DateTime.now().obs;
  var doubleTypeCurrentTime = 1.0.obs; // 현재 시간은 더블 타입으로 바꾼것
  List<double> myCouncelStartTimeList =
      []; // 내 상담의 시작 시간 리스트 (myCouncelList 의 인덱스 순서와 같다.)
  List<double> myCouncelEndTimeList =
      []; // 내 상담의 종료 시간 리스트 (myCouncelList 의 인덱스 순서와 같다.)

  RxInt myPickCouncelor = 0.obs; // 내가 선택한 관리자의 ID
  RxList councelorList = <MyCouncelor>[].obs; // 나를 담당하고 있는 관리자 리스트

  RxString myPickDateDisplay = ''.obs; // 내가 선택한 상담 날짜 화면 출력용 -> 2023년 03월 01일
  RxString myPickDateServe = ''.obs; // 내가 선택한 상담 날짜 서버 전송용 -> 2023-03-01

  RxString myPickTime = ''.obs; // 내가 선택한 날짜 스트링 타입으로 13:00 이런식
  List reservedTime = <double>[].obs; // 이미 예약된 시간들

  RxString myInputTitle = ''.obs; // 입력한 제목
  RxString myInputCategory = ''.obs; // 입력한 카테고리

  RxInt adminCategory = 1.obs; // 관리가 페이지의 탭바 인덱스


  @override
  void onInit() {
    super.onInit();
    initialRun();
  }

  void initialRun() async {
    await fetchMyCouncelList();
    await fetchCouncelor(userClassNum, userRegionCode);
  }

  // 내 상담신청 현황 요청
  // userId : 학번, code : 학생, 관리자 구분 코드
  Future fetchMyCouncelList() async {
    int? userId = userID;
    int? isAdmin = userAdmin;

    loadingController.to.isLoading = true; // 비동기 로딩화면 출력

    myCouncelList.clear(); // 초기화 는 clear 로 해야만 되는듯
    myCouncelStartTimeList = <double>[]; // 시작시간 종료 시간도 초기화
    myCouncelEndTimeList = <double>[];

    // 유저정보를 가져오지 못했을 경우 리스트를 초기화한 채로 함수 종료
    if (userId == null || isAdmin == null) {
      loadingController.to.isLoading = false;
      return ;
    }

    await setNowTime(); // 요청 시간을 기준으로 시간 설정 -> 프로그래스바 등에서 사용할거임
    var res = await http
        .get(Uri.parse("http://i8a602.p.ssafy.io:9090/meet/${userId}/${isAdmin}"));
    var data = json.decode(res.body);


    for (int i = 0; i < data.length; i++) {
      final obj = CouncelDetail.fromJson(data[i]).obs; // obj's type == councelDetail
      if (userAdmin == 1) {
        // 관리자 (userAdmin == 1) 일때는 상단 탭에 따라서 리스트에 저장하는 값을 달리함
        if (obj.value.state == adminCategory.value) { // adminCategory.value 가 고유값
          myCouncelList.add(obj);
          int K = myCouncelList.length; // startTime endTime 에는 항상 councelList 하고 같은 크기가 된다.
          myCouncelStartTimeList.add(calculatorTimeOfClass(
              myCouncelList[K-1].value.rezDate, myCouncelList[K-1].value.rezTime));
          myCouncelEndTimeList.add(myCouncelStartTimeList[K-1] +
              100 // 상담은 1시간 한다고 가정해서 +100임 1이 시간 00이 분이라서
          );
        }
      } else {
        // 학생일 경우는 모든 상담을 담는다. => 백에서 데이터를 정렬해서 보내주기에 그대로 출력하면 됨
        myCouncelList.add(obj);
        myCouncelStartTimeList.add(calculatorTimeOfClass(
            myCouncelList[i].value.rezDate, myCouncelList[i].value.rezTime));
        myCouncelEndTimeList.add(myCouncelStartTimeList[i] +
            100 // 상담은 1시간 한다고 가정해서 +100임 1이 시간 00이 분이라서
        );
      }
    }
    loadingController.to.isLoading = false; // 비동기 로딩화면 종료
  }

  // 현재시간 초기화해서 doubleTypeCurrentTime 에 넣어줌
  Future setNowTime() async {
    currentTime = await DateTime.now().obs;
    calculatorTime(currentTime.value);
  }

  // DateTime 형태 (CouncelDetail 클래스 는 변환 안됨)
  // 현재 시간, 년 월 일 시 분 을 숫자로 변환 2023-03-15 13:32 을 202303151332 로 바꿔줌
  void calculatorTime(DateTime time) {
    String year = time.year.toString();
    String mon = time.month.toString();
    String day = time.day.toString();
    mon.length == 1 ? mon = '0' + mon : null;
    day.length == 1 ? day = '0' + day : null;
    String tmpDate = year + mon + day;

    String hour = time.hour.toString();
    String min = time.minute.toString();
    hour.length == 1 ? hour = '0' + hour : null;
    min.length == 1 ? min = '0' + min : null;
    String tmpTime = hour + min;

    double value = double.parse((tmpDate + tmpTime));
    doubleTypeCurrentTime.value = value;
  }

  // CouncelDetail 클래스의 시간을 변환 rezDate : 2023-02-22 rezTime: 13.5 -> 202302221330 으로
  double calculatorTimeOfClass(DateTime rezDate, double rezTime) {
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

  // [반] 과 [지역코드] 로 그 반 관리자들 호출해서 리스트에 저장
  Future fetchCouncelor(int? classNum, int? region) async {
    councelorList.clear(); // 우선 리스트 초기화

    // 유저정보를 불러오지 못한 경우에 그대로 종료
    if (classNum == null || region == null) {
      return ;
    }

    loadingController.to.isLoading = true; // 비동기 로딩화면 출력
    var res = await http.get(Uri.parse(
        'http://i8a602.p.ssafy.io:9090/reserve/info?classNum=${classNum}&regionCode=${region}'));
    List data = json.decode(res.body);
    // 리스트를 초기화 했기 때문에 200 일때만 고려하면 됨
    if (res.statusCode == 200) {
      data.forEach((ele) {
        councelorList.add(MyCouncelor(
          isAdmin: ele["is_admin"],
          userName: ele["user_name"],
          userIdx: ele["user_idx"],
          userImg: ele["user_img"],
        ));
      });
    }
    loadingController.to.isLoading = false; // 비동기 로딩화면 종료
  }

  // 관리자 선택하기
  void selectCouncelor(int idx) {
    // 관리자가 다시 선택되면 날짜 컨트롤러 값 초기화 시킴
    myPickDateServe.value = '';
    myPickDateDisplay.value = '';
    myPickTime.value = ''; // 시간 선택 컨트롤러도 초기화

    if (myPickCouncelor.value == idx) {
      myPickCouncelor.value = 0; // 이미 선택한 관리자를 눌렀을때의 행동 == 취소
    } else {
      myPickCouncelor.value = idx;
    }
  }

  // 달력 선택시에 반영하고 관리자 + 날짜로 예약 현황 API 호출한다.
  void selectDateAndFetchReservation(List dateList) async {
    const Map<String, String> Eformat = {
      'Sun': '일',
      'Mon': '월',
      'Tue': '화',
      'Wed': '수',
      'Thu': '목',
      'Fri': '금',
      'Sat': '토',
    };
    var EE = Eformat[dateList[3]]; // 요일
    myPickDateDisplay.value =
        '${dateList[0]}년 ${dateList[1]}월 ${dateList[2]}일 (${EE})'; // 출력용 형식 0000년 00월 00일
    myPickDateServe.value = '${dateList[0]}-${dateList[1]}-${dateList[2]}'; // 서버 전송용 형식 0000-00-00

    int managerId = myPickCouncelor.value; // 내가 선택한 관리자 아이디
    String date = myPickDateServe.value; // 내가 선택한 날짜 서버 전송용

    var res = await http.get(Uri.parse(
        "http://i8a602.p.ssafy.io:9090/reserve/time?date=${date}&managerId=${managerId}"));
    var data = json.decode(res.body);

    // 시간 선택 컨트롤러는 미리 생성해 놓았다.
    myPickTime.value = "";
    reservedTime.clear();
    reservedTime.assignAll(
        List<double>.from(data['time'].map((x) => x))); // 예약된시간들을 넣어 놓는다.
  }

  // 시간 선택
  void select(String time) {
    if (time == myPickTime.value) {
      myPickTime.value = ''; // 선택 상태에서 함더 누름 취소
    } else {
      myPickTime.value = time;
    }
  }


  // 상담승인, rezIdx : 승인할 상담 id, councelDetail 의 state 값을 2로 변경요청
  Future acceptCouncel(int rezIdx) async{

    loadingController.to.isLoading = true;
    var res = await http.put(Uri.parse(
        'http://i8a602.p.ssafy.io:9090/meet/update/accept?rez_idx=${rezIdx}'));
    loadingController.to.isLoading = false;

    await fetchMyCouncelList(); // 상담 현황 다시 요청해서 랜더링
  }

  // 상담 거절, rezIdx : 거절할 상담 id, comment : 거절 멘트, councelDetail 의 state 값을 3으로 변경요청
  Future rejectCouncel(int rezIdx, String comment) async{

    loadingController.to.isLoading = true;
    var res = await http.put(Uri.parse(
        'http://i8a602.p.ssafy.io:9090/meet/update/reject?rez_idx=${rezIdx}&reject=${comment}'));
    loadingController.to.isLoading = false;

    await fetchMyCouncelList(); // 상담 현황 다시 요청
  }


  // 상담 신청 제출
  void submitCouncelApplication() async {
    int studentId = userID ?? 0;
    // 이하 유저가 선택한 데이터 들
    int managerId = myPickCouncelor.value;
    String rezDate = myPickDateServe.value;
    String rezTime = myPickTime.value;
    String title = myInputTitle.value;
    String category = myInputCategory.value;

    var body = json.encode({
      "studentId" : studentId,
      "managerId" : managerId,
      "rezDate" : rezDate,
      "rezTime" : rezTime,
      "title" : title,
      "category" : category,
    });

    loadingController.to.isLoading = true;
    var headers = {"Content-Type": "application/json"};
    await http.post(Uri.parse('http://i8a602.p.ssafy.io:9090/reserve/submit'), headers: headers, body: body);
    loadingController.to.isLoading = false;

    await fetchMyCouncelList(); // 상담 요청 보내면 목록 갱신하여 랜더링

  }

  // 관리자 상담 페이지에서 관리자가 선택한 탭의 고유값
  void selectAdminCategory(int x) async{
    adminCategory.value = x;
    await fetchMyCouncelList();
  }

  // 상담 종료 webrtc를 종료하면 상담시간이 다 끝나지 않았어도 종료 요청, state 를 4로 변경
  Future endCouncel(int rezIdx) async{

    loadingController.to.isLoading = true;
    await http.put(Uri.parse(
        'http://i8a602.p.ssafy.io:9090/meet/update/end?rez_idx=${rezIdx}'));
    loadingController.to.isLoading = false;

    await fetchMyCouncelList(); // 상담 현황 다시 요청
  }

}
