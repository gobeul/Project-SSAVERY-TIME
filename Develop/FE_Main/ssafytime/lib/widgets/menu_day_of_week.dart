import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/loading_controller.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/custom_text.dart';
import 'package:ssafytime/widgets/loading_indicator.dart';
import 'package:ssafytime/widgets/menu_book_item.dart';
import '../controllers/menu_week_controller.dart';
import 'menu_detail.dart';

class MDay0fWeek extends StatelessWidget {
  MDay0fWeek({Key? key}) : super(key: key);

  MenuPickDayController controller = Get.put(MenuPickDayController());

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
    Map<int, List> dayList = {
      0: ['월', dt.subtract(Duration(days: dt.weekday - 1)).day.toString()],
      1: ['화', dt.subtract(Duration(days: dt.weekday - 2)).day.toString()],
      2: ['수', dt.subtract(Duration(days: dt.weekday - 3)).day.toString()],
      3: ['목', dt.subtract(Duration(days: dt.weekday - 4)).day.toString()],
      4: ['금', dt.subtract(Duration(days: dt.weekday - 5)).day.toString()],
    };

    return Obx(
      () => Column(
        children: [

          Container(
            color: Colors.black12,
            height: MediaQuery.of(context).size.height * ( 48 / 803),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                VerticalDivider(
                    thickness: 1, width: 1, color: (controller.myPick.value == 0) ? Color(0xff3396F4) : Color(0xffC3C6CF)),
                for (int idx = 0; idx < 5; idx++) ...[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    width: MediaQuery.of(context).size.width * ( 76.8 / 392.7),
                    child: InkWell(
                      onTap: () {
                        controller.selectDay(idx);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              dayList[idx]![0],
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: (controller.myPick.value == idx
                                      ? Color(0xff3396F4)
                                      : Color(0x40000000))),
                            ),
                          ),
                          Container(
                            child: Text(
                              dayList[idx]![1],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: (controller.myPick.value == idx
                                      ? Color(0xff3396F4)
                                      : Color(0x40000000))),
                            ),
                          ),
                          Container(
                            // width: 65,
                            width: MediaQuery.of(context).size.width * ( 65 / 392.7),
                            color: (controller.myPick.value == idx
                                ? Color(0xff3396F4)
                                : Color(0x003396F4)),
                            height: MediaQuery.of(context).size.height * ( 3 / 803),
                          )
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                      thickness: 1, width: 1, color: (controller.myPick.value == idx || controller.myPick.value == idx+1) ? Color(0xff3396F4) : Color(0xffC3C6CF)),
                ],
              ],
            ),
          ),

          // 메뉴 카드들 =========
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            height: controller.menuofday.length != 0 ? 610 : 300,
            child: controller.menuofday.length != 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.menuofday.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                        child: InkWell(
                      onTap: () {
                        openMenuDetail(context, controller.menuofday[index].id);
                      },
                      child: MIW(
                        imgUrl: controller.menuofday[index].imageUrl,
                        foodKcal: controller.menuofday[index].kcal,
                        mainMenu: controller.menuofday[index].mainMenu,
                        subMenuList: controller.menuofday[index].sideMenu,
                      ),
                    ));
                  })
              // api 에서 메뉴 정보를 못가져 올때
              : Container(
                  // width: 390, height: 300,
                  child: Column(
                    children: [
                      Container(
                        // width: 365,
                        width: MediaQuery.of(context).size.width * ( 365 / 392.7),
                        // height: 288,
                        height: MediaQuery.of(context).size.height * ( 288 / 803),
                        decoration: BoxDecoration(
                          color: Color(0x08000000),
                          border: Border.all(width: 2, color: Color(0x05000000)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.asset('assets/image/no_week_menu.png', fit: BoxFit.contain),
                            CustomText(content: '아직 올라온 데이터가 없습니다',)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
