import 'package:flutter/material.dart';
import 'package:ssafytime/controllers/user_controller.dart';
import 'package:ssafytime/custom_button.dart';
import 'package:get/get.dart';

import '../controllers/councel_controller.dart';
import 'councel_list_item.dart';



class CMyCouncel extends StatelessWidget {

  CMyCouncel({Key? key}) : super(key: key);

  MyCouncelController controller = Get.put(MyCouncelController());


  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      width: MediaQuery.of(context).size.width * ( 390 / 392.7),
      height: MediaQuery.of(context).size.height * ( 666 / 803),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchMyCouncelList();
            print(controller.myCouncelList[0]);
          },
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Divider(thickness: 2, height: 6, color: Color(0xffC3C6CF),),

              for (int i=0; i < controller.myCouncelList.length; i++) ... [
                CouncelListItem(
                  startTime: controller.myCouncelStartTimeList[i],
                  endTime: controller.myCouncelEndTimeList[i],
                  rezTime: controller.myCouncelList[i].value.rezTime,
                  currentTime: controller.doubleTypeCurrentTime.value,
                  title: controller.myCouncelList[i].value.title,
                  reject : controller.myCouncelList[i].value.reject,
                  state: controller.myCouncelList[i].value.state,
                  sessionId : controller.myCouncelList[i].value.sessionId,
                  rezIdx : controller.myCouncelList[i].value.rezIdx,
                ),
                Divider(thickness: 2, height: 6, color: Color(0xffC3C6CF),),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 현재 시간, 년 월 일 시 분 을 숫자로 변환
double calculatorTime(DateTime time) {
  String s = '';
  String t = '';
  s = time.year.toString() + time.month.toString() + time.day.toString();
  t = (time.hour.toInt() + (time.minute.toInt()/60)).toStringAsFixed(2).toString();
  double v = double.parse((s+t));
  return v;
}
