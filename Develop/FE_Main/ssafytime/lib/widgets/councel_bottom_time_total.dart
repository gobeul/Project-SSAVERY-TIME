import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/councel_controller.dart';
import '../model/councel_bottom.dart';
import 'councel_bottom_time_item.dart';

class CBTimeTotal extends StatelessWidget {
  CBTimeTotal({Key? key}) : super(key: key);

  MyCouncelController controller = Get.find<MyCouncelController>();

  @override
  Widget build(BuildContext context) {
    staticTimeTable table = staticTimeTable();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: MediaQuery.of(context).size.width * ( 390 / 392.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, thickness: 2, color: Colors.grey,),
          SizedBox(height: MediaQuery.of(context).size.height * ( 20 / 803),),
          SizedBox(
            child: Text('상담 시간',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),),
          ),
          Obx(() => Container(
              // height: 100,
            height: MediaQuery.of(context).size.height * ( 100 / 803),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < 3; i ++) ... [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (double j = 9; j <= 11.5; j += 0.5) ... [
                          // j + i*3
                          if (j+i*3 == 12.0 || j+i*3 == 12.5) ... [
                            CBLunchItem() // 점심 위젯
                          ] else if (controller.reservedTime.contains(j+i*3)) ... [
                            CBReservedTime(time: table.table[j+i*3],) // 이미 예약됨
                          ] else ... [
                            CBTimeItem(time: table.table[j+i*3])
                            // 나중에 예약된 상담 막아 놓는 기능 추가 필요함.
                          ],
                        ],
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),),
        ],
      )
    );
  }
}
