import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ssafytime/controllers/loading_controller.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'dart:convert';
import '../model/menu_week_v2.dart';

// 주간 식단표 컨트롤러
class MenuPickDayController extends GetxController {
  static MenuPickDayController get to => Get.find();
  RxInt myPick = 0.obs; // 월 ~ 금 까지 0 부터 4 까지의 인덱스를 가진다.
  List dayofweek = [0, 0, 0, 0, 0]; // 이번주 월 ~ 금의 日 표시
  DateTime today = DateTime.now();
  var menusofweek = <List>[].obs; // 월 ~ 금 메뉴가 모두 들어 있는 리스트
  var menuofday = [].obs; // 유저가 선택한 날짜의 메뉴가 들어 있는 리스트

  @override
  void onInit() {
    initialRun();
    super.onInit();
  }

  // 초기 실행행
 void initialRun() async {
    // loadingController.to.isLoading = true; // 일단 로딩 표시 on
    // 지역 번호 넣어서 메뉴 요청
    await requstMenuWeek(AuthService.to.user.value.regionCode ?? 0);

    // 오늘 날짜 확인하기
    for (int i = 0; i < 5; i++) {
      DateTime tmp = today.subtract(Duration(days: today.weekday - (i + 1))); // -1 부터 -4 까지 넣음으로서 월 ~ 금 의 날짜(DateTime)를 뽑을 수 있다.
      dayofweek[i] = tmp.day; // 이번 주 월 ~ 금 의 날짜 채우기
    }
    selectDay(0); // 주말의 경우 월요일(0)꺼 보여주기
    for (int i = 0; i < 5; i++) {
      if (today.day == dayofweek[i]) { // 오늘 日하고 같은 일의 있다면
        myPick.value = i; // myPick 의 초기값을 그 요일로 선택한다. = 마치 앱을 처음 실행하면 오늘 날짜가 자동으로 선탣되어 있도록
        selectDay(i); // 그 요일 선택
      }
    }
    // loadingController.to.isLoading = false; // 로딩 표시 off
  }


  // 이번주 식단 가져오기
  Future<void> requstMenuWeek(int region) async {
    // loadingController.to.isLoading = true; // 일단 로딩 표시 on

    menusofweek = <List>[].obs;
    var res = await http.get(
        Uri.parse("http://i8a602.p.ssafy.io:9090/menu/week/?region=${region}"));
    var data = json.decode(res.body);

    final dataList = data['data'].values.map((x) => x).toList();
    print('dataList : ${dataList}');

    for (int i = 0; i < dataList.length; i++) {
      var menus = <MenuWeekV2>[].obs;
      for (int j = 0; j < dataList[i].length; j++) {
        menus.add(MenuWeekV2(
          id: dataList[i][j]["id"],
          mainMenu: dataList[i][j]["mainMenu"],
          sideMenu: List<String>.from(dataList[i][j]["sideMenu"].map((x) => x)),
          kcal: dataList[i][j]["kcal"],
          imageUrl: dataList[i][j]["imageUrl"],
        ));
      }
      menusofweek.add(menus);
    };
    // loadingController.to.isLoading = false; // 로딩 표시 off
  }

  // 날짜 선택하기
  void selectDay(int idx) {
    print('날짜 선택');
    myPick.value = idx;
    menuofday = menusofweek[idx].obs; // 선택한 날짜의 메뉴로 바꾼다.
  }
}
