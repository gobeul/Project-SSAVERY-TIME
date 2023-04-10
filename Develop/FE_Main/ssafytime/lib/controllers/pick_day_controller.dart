import 'package:get/get.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';

class PickDayController extends GetxController {
  RxInt myPick = 0.obs; // 월 ~ 금
  List dayofweek = [0, 0, 0, 0, 0];
  DateTime today = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    initialRun();
    initialRun();
  }


  void initialRun() {
    for (int i = 0; i < 5; i++) {
      DateTime tmp = today.subtract(Duration(days: today.weekday - (i + 1)));
      dayofweek[i] == tmp.day;
    }
    for (int i = 0; i < 5; i++) {
      if (today.day == dayofweek[i]) {
        myPick.value == i;
      }
    }
  }

  void selectDay(int idx) {
    myPick.value = idx;
  }
}

