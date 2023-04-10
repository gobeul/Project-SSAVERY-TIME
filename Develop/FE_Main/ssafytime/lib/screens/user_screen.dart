// user setting screen

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/user_controller.dart';
import 'package:ssafytime/controllers/user_state_controller.dart';
import 'package:ssafytime/custom_button.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/user_screen_attendance_state_widget.dart';
import 'package:ssafytime/widgets/user_screen_mileage.dart';
import 'package:ssafytime/widgets/user_screen_user_info_widget.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserScreenStates();
}

class _UserScreenStates extends State<UserScreen> {
  UserController userC = UserController.to;
  UserStateController stateC = Get.find<UserStateController>();
  TextEditingController _titleController = TextEditingController();
  String test = "테스트";

  var dateSelect = {
    "월": 0,
    "화": 1,
    "수": 2,
    "목": 3,
    "금": 4,
    "토": 5,
    "일": 6,
  };

  @override
  void dispose() {
    _titleController.dispose();
    log("AlarmState : ${stateC.defaultAlarms.value.surveyAlarm}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("마이페이지"),
      ),
      body: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MUI(
                name: AuthService.to.user.value.userName,
                studentID: AuthService.to.user.value.userIdx,
                imgURL: AuthService.to.user.value.userImg,
              ),
              Divider(),
              MAW(
                absentO: userC.userAtten.value.absentO,
                absentR: userC.userAtten.value.absentR,
                lateR: userC.userAtten.value.lateR,
                lateO: userC.userAtten.value.lateO,
                attenN: userC.userAtten.value.attenN,
                attenT: userC.userAtten.value.attenT,
              ),
              Divider(),
              MMileage(myMileage: AuthService.to.user.value.mileage),
              Divider(),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "기본 알림 설정",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SwitchListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          contentPadding: EdgeInsets.fromLTRB(32, 0, 16, 0),
                          title: Text("공지사항 알림"),
                          value: stateC.defaultAlarms.value.noticeAlarm,
                          onChanged: (bool value) {
                            setState(() {
                              stateC.updateNoticeAlarm(value);
                            });
                          },
                        ),
                        Divider(),
                        SwitchListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          contentPadding: EdgeInsets.fromLTRB(32, 0, 16, 0),
                          title: Text("설문조사 알림"),
                          value: stateC.defaultAlarms.value.surveyAlarm,
                          onChanged: (bool value) {
                            setState(() {
                              stateC.updateSurveyAlarm(value);
                            });
                          },
                        ),
                        Divider(),
                        SwitchListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          contentPadding: EdgeInsets.fromLTRB(32, 0, 16, 0),
                          title: Text("상담 알림"),
                          value: stateC.defaultAlarms.value.consultingAlarm,
                          onChanged: (bool value) {
                            setState(() {
                              stateC.updateCounselAlarm(value);
                            });
                          },
                        ),
                        Divider()
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "개인 알림 설정",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "",
                                  titlePadding:
                                      EdgeInsets.only(top: 0, bottom: 0),
                                  contentPadding: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8),
                                  textConfirm: "등록",
                                  textCancel: "취소",
                                  onCancel: () {
                                    _titleController.clear();
                                    stateC.initDateSelectItem();
                                  },
                                  onConfirm: () {
                                    stateC
                                        .addCustomState(_titleController.text);
                                    stateC.initDateSelectItem();
                                    Get.back();
                                  },
                                  content: Obx(() => setCustomAlarmDialog()),
                                );
                              },
                              icon: FaIcon(FontAwesomeIcons.plus))
                        ],
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        child: stateC.customState.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: stateC.customState.length,
                                itemBuilder: ((context, index) =>
                                    SwitchListTile(
                                        title: Text(
                                            stateC.customState[index].title),
                                        subtitle: Text(
                                            "${stateC.customState[index].time.hour}:${stateC.customState[index].time.minute} / ${stateC.customState[index].dateSelected.toString()}"),
                                        value: stateC.customState[index].isOn,
                                        secondary: IconButton(
                                          icon: FaIcon(FontAwesomeIcons.eraser),
                                          onPressed: () => {
                                            Get.defaultDialog(
                                              title: "",
                                              titlePadding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
                                              content: const Text("삭제하시겠습니까?"),
                                              textConfirm: "확인",
                                              textCancel: "취소",
                                              onConfirm: () => {
                                                stateC.removeCustomState(index),
                                                Get.back()
                                              },
                                            )
                                          },
                                        ),
                                        onChanged: ((value) {
                                          setState(() {
                                            stateC.customState[index].isOn =
                                                value;
                                          });
                                          if (value) {
                                            stateC.onCustomState(index);
                                          } else {
                                            stateC.offCustomState(index);
                                          }
                                        }))),
                              )
                            : Text("등록된 알람이 없습니다"),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (15 / 803),
                child: Divider(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (20 / 803),
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        AuthService.to.logout();
                      },
                      width: MediaQuery.of(context).size.width * (200 / 392.7),
                      height: MediaQuery.of(context).size.height * (40 / 803),
                      label: '로그아웃',
                      labelColor: 0xffFFFFFF,
                      color: 0xff3094F2,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (20 / 803),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget setCustomAlarmDialog() {
    return Column(
      children: [
        TimePickerSpinner(
          is24HourMode: false,
          // itemHeight: 40,
          itemHeight: MediaQuery.of(context).size.height * (40 / 803),
          // itemWidth: 60,
          itemWidth: MediaQuery.of(context).size.width * (60 / 392.7),
          onTimeChange: (time) {
            stateC.dateTime.value = time;
          },
        ),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: "알람 제목"),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: dateSelect.keys
                .map(
                  ((e) => FilterChip(
                        showCheckmark: false,
                        label: Text(e),
                        onSelected: (bool value) {
                          if (value) {
                            if (!stateC.dateSelected.contains(e)) {
                              stateC.dateSelected.add(e);
                            }
                          } else {
                            stateC.dateSelected
                                .removeWhere((element) => element == e);
                          }
                        },
                        selected: stateC.dateSelected.contains(e),
                      )),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
