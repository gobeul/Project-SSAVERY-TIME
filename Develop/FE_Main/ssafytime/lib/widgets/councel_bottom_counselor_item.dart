import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/councel_controller.dart';


class CBCounselorItem extends StatelessWidget {

  final String name; // 이름
  final String position; // 컨설턴트, 프로, 등의 담당업무?
  final String imgUrl; // 이미지 URL
  final int managerId; // 관리자 ID


  CBCounselorItem({Key? key,
    required this.name,
    required this.position,
    required this.imgUrl,
    required this.managerId
  }) : super(key: key);


  MyCouncelController controller = Get.find<MyCouncelController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
        onTap: () {
          controller.selectCouncelor(managerId);
          FocusScope.of(context).unfocus(); // 키보트 포커스 아웃
        },
        child: Container(
          width: MediaQuery.of(context).size.width * ( 71 / 392.7),
          height: MediaQuery.of(context).size.height * ( 84 / 803),
          decoration: BoxDecoration(
            color: controller.myPickCouncelor.value == managerId ? Color(0xffE7E7E7) : Colors.white,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(imgUrl),
                  ),
                ),
              ),
              Container(
                child: Text(name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11),),
              ),
              Container(
                child: Text(position, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
