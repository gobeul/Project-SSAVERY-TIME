import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ssafytime/repositories/notification_repository.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/notification_infomation.dart';

/**
 * 알림 페이지 컨트롤러
 * methods :
 *      fetchNotiList : 알림 목록 초기화 및 불러오기
 *      fetchNoticeList : 공지사항 목록 불러오기
 *      completeSurveyList : 사용자가 완료한 설문조사 목록 불러오기
 *      fetchSurveyList : 설문조사 목록 불러오기
 *      fetchCounselList : 상담 목록 불러오기
 *      fetchNotiListWidgets : 불러온 알림 목록으로 알림 목록 Widget 생성
 */
class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static NotificationController get to => Get.find();
  var count = 0.obs;

  final notiList = [
    <dynamic>[].obs,
    <dynamic>[].obs,
    <dynamic>[].obs,
    <dynamic>[].obs,
  ];
  final completeSurveys = [].obs;
  final notiListWidgets = <Widget>[].obs;

  final dateF = new DateFormat("yy/MM/dd");
  final timeF = new DateFormat("yy/MM/dd HH:mm");

  final NotiRepo notiApi = NotiRepo(token: AuthService.to.accessToken.value);

  late TabController tabController;

  final List<Tab> myTabs = <Tab>[
    const Tab(
      child: Text("전체"),
    ),
    const Tab(
      child: Text("공지사항"),
    ),
    const Tab(
      child: Text("설문조사"),
    ),
    const Tab(
      child: Text("상담"),
    ),
  ];

  @override
  void onInit() async {
    tabController = TabController(length: myTabs.length, vsync: this);
    tabController.addListener(() {
      log("tab num : ${tabController.index}");
      fetchNotiListWidgets();
    });
    await fetchNotiList();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchNotiList() async {
    completeSurveys.clear();
    notiList[0].clear();
    notiList[1].clear();
    notiList[2].clear();
    notiList[3].clear();
    await completeSurveyList();
    await fetchNoticeList();
    await fetchSurveyList();
    await fetchCounselList();
    notiList[0].sort((b, a) => a.createDateTime.compareTo(b.createDateTime));
    notiList[1].sort((b, a) => a.createDateTime.compareTo(b.createDateTime));
    notiList[2].sort((b, a) => a.createDateTime.compareTo(b.createDateTime));
    notiList[3].sort((b, a) => a.createDateTime.compareTo(b.createDateTime));
    fetchNotiListWidgets();
  }

  Future<void> fetchNoticeList() async {
    var data = await notiApi.fetchNoticeList();
    if (data != null) {
      data.forEach((e) {
        notiList[0].add(e);
        notiList[1].add(e);
      });
    }
  }

  Future<void> completeSurveyList() async {
    var data = await notiApi.completeSurveyList();
    if (data != null) {
      data.forEach((element) {
        completeSurveys.add(element.surveyIdx);
      });
      log("-------------- ${completeSurveys}");
    }
  }

  Future<void> fetchSurveyList() async {
    var data = await notiApi.fetchSurveryList();
    if (data != null) {
      data.forEach((e) {
        if (e.createDateTime != null) {
          if (completeSurveys.contains(e.surveyIdx)) {
            e.status = 3;
          }
          notiList[0].add(e);
          notiList[2].add(e);
        }
      });
    }
  }

  Future<void> fetchCounselList() async {
    var data = await notiApi.fetchCounselList(
        AuthService.to.user.value.userIdx, AuthService.to.user.value.isAdmin);
    if (data != null) {
      data.forEach((e) {
        notiList[0].add(e);
        notiList[3].add(e);
      });
    }
  }

  void fetchNotiListWidgets() {
    notiListWidgets.clear();
    notiList[tabController.index].forEach(
      (element) {
        switch (element.notiType) {
          case 1:
            notiListWidgets.add(CNI(
                opacity: 1,
                myIcon: FontAwesomeIcons.bullhorn,
                iconColor: 0xffFF5449,
                title: element.title,
                detail: Text(timeF.format(element.createDateTime)),
                isComplete: ""));
            notiListWidgets.add(Divider(
              height: 4,
            ));
            break;
          case 2:
            notiListWidgets.add(GestureDetector(
              child: CNI(
                  opacity: _setSurveyOpacity(element.status),
                  myIcon: FontAwesomeIcons.pen,
                  iconColor: 0xff0079D1,
                  title: element.title,
                  detail: Text(
                      "${timeF.format(element.startDate)} ~ ${timeF.format(element.endDate)}"),
                  isComplete: _setSurveyIsComplete(element.status)),
              onTap: () {
                AuthService.to.user.value.isAdmin == 0 && element.status == 1
                    ? Get.defaultDialog(
                        title: "",
                        titlePadding: EdgeInsets.only(top: 0, bottom: 0),
                        content: Text("설문을 진행하시겠습니까?"),
                        textConfirm: "계속",
                        textCancel: "취소",
                        onConfirm: () {
                          Get.back();
                          Get.toNamed('/survey', arguments: {
                            "surveyIdx": element.surveyIdx,
                            "surveyTitle": element.title
                          });
                        },
                      )
                    : "";
              },
            ));
            notiListWidgets.add(Divider(
              height: 4,
            ));
            break;
          case 3:
            notiListWidgets.add(CNI(
                opacity: _setCounselOpacity(element.state),
                myIcon: FontAwesomeIcons.userGroup,
                iconColor: 0xff686ADB,
                title: element.title,
                detail:
                    Text("${dateF.format(element.rezDate)} ${element.rezTime}"),
                isComplete: _setCounselIsComplete(element.state)));
            notiListWidgets.add(Divider(
              height: 4,
            ));
            break;
        }
      },
    );
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
