import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/user_controller.dart';

import 'home_employment_info_single_widget.dart';

// 홈 스크린 채용정보 전체 위젯
class HEIT extends StatelessWidget {
  HEIT({
    Key? key,
  }) : super(key: key);
  UserController controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {

    return Obx(() => Container(
      width: MediaQuery.of(context).size.width * ( 358 / 392.7),
      height: MediaQuery.of(context).size.height * ( 300 / 803),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: Text(
                '채용정보 ${controller.recruitCnt.value}건',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
            if (controller.recruitmentList.data == []) ... [
              SizedBox(
                // height: 200,
                height: MediaQuery.of(context).size.height * ( 200 / 803),
                child: Center(
                  child: Text(
                    '채용 중인 회사가 없습니다.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0x47000000)),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.recruitmentList.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HEIS(info: controller.recruitmentList.data[index]),
                          Container(
                            width: MediaQuery.of(context).size.width * ( 326 / 392.7),
                            height: 1,
                            color: const Color(0xffC3C6CF),
                          )
                        ],
                      );
                    }
                  ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
