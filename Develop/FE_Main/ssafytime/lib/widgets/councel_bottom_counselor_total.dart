import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/councel_controller.dart';
import 'councel_bottom_counselor_item.dart';

class CBCouncelorTotal extends StatelessWidget {


  List<String> adminCode = ['학생', '컨설턴트', '프로', '교수', '코치', '취업'];

  CBCouncelorTotal({Key? key,
  }) : super(key: key);

  MyCouncelController controller = Get.find<MyCouncelController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * ( 390 / 392.7),
        height: MediaQuery.of(context).size.height * ( 92 / 803),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i=0; i < controller.councelorList.length; i++) ... [
              CBCounselorItem(
                name: controller.councelorList[i].userName,
                position: adminCode[controller.councelorList[i].isAdmin],
                imgUrl: 'assets/image/no_profile_image.png', // 임시 방편
                managerId: controller.councelorList[i].userIdx,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
