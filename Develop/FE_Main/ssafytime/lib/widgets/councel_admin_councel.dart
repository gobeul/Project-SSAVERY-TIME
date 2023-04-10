import 'package:flutter/material.dart';
import 'package:get/get.dart' ;
import 'package:ssafytime/widgets/councel_list_admin_item.dart';
import 'package:ssafytime/widgets/custom_text.dart';
import '../controllers/councel_controller.dart';


// 관리자에게 온 상담 신청 현황 전체 위젯
class CAdminCouncel extends StatelessWidget {

  CAdminCouncel({Key? key}) : super(key: key);

  MyCouncelController controller = Get.put(MyCouncelController());

  Map<int, String> table = {
    1: '신청',
    2: '승인',
    3: '반려',
    4: '종료',
  };


  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * ( 390 / 392.7),
            height: MediaQuery.of(context).size.height * ( 48 / 803),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VerticalDivider(
                    thickness: 2, width: 1, color: controller.adminCategory == 1 ? Color(0xff3396F4) : Color(0xffC3C6CF)
                ),
                for (int idx = 1; idx < 5; idx++) ...[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: MediaQuery.of(context).size.width * ( 76.8 / 392.7),
                    child: InkWell(
                      onTap: () {
                        controller.selectAdminCategory(idx);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              table[idx]!,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: (controller.adminCategory.value == idx
                                      ? Color(0xff3396F4)
                                      : Color(0x40000000))),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * ( 70 / 392.7),
                            height: MediaQuery.of(context).size.height * ( 3 / 803),
                            decoration: BoxDecoration(
                              color: (controller.adminCategory.value == idx
                                  ? Color(0xff3396F4)
                                  : Color(0x003396F4)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(controller.adminCategory.value == idx ? 0.6 : 0) ,
                                  blurRadius: 2.0,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                    thickness: 2, width: 1,
                    color: (controller.adminCategory == idx || controller.adminCategory == idx+1) ? Color(0xff3396F4) : Color(0xffC3C6CF)
                  ),
                ],
              ],
            ),
          ),


          Container(
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            width: MediaQuery.of(context).size.width * ( 390 / 392.7),
              height: MediaQuery.of(context).size.height * ( 600 / 803),
              child: SingleChildScrollView(

                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          CustomText(content: '상담 ${table[controller.adminCategory.value]}', fontSize: 25,),
                          Container(
                            constraints: BoxConstraints(
                              // maxHeight: 500,
                              maxHeight: MediaQuery.of(context).size.height * ( 500 / 803)
                            ),
                            child: RefreshIndicator(
                              onRefresh: () async{
                                controller.fetchMyCouncelList();
                              },
                              child: ListView.builder(
                                itemCount: controller.myCouncelList.length,
                                itemBuilder: (context, idx) {
                                  return ListTile(
                                    title: Container(
                                      child: CouncelAdminListItem(
                                        data: controller.myCouncelList[idx],
                                        currentTime: controller.doubleTypeCurrentTime.value,
                                        startTime: controller.myCouncelStartTimeList[idx],
                                        endTime: controller.myCouncelEndTimeList[idx],
                                      ),
                                      margin: EdgeInsets.only(bottom: 5),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}

//
// 현재 시간, 년 월 일 시 분 을 숫자로 변환
double calculatorTime(DateTime time) {
  String s = '';
  String t = '';
  s = time.year.toString() + time.month.toString() + time.day.toString();
  t = (time.hour.toInt() + (time.minute.toInt()/60)).toStringAsFixed(2).toString();
  double v = double.parse((s+t));
  return v;
}
