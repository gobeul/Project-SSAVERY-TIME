import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/bottom_navbar_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavBar extends GetView<BottomNavigationBarController> {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedIdx.value,
        // 요소(item)을 탭 할 시 실행)
        onTap: controller.changeIdx,
        // 선택에 따라 icon·label 색상 변경
        selectedItemColor: const Color(0xff3396F4),
        unselectedItemColor: const Color(0x40000000),
        // 선택에 따라 label text style 변경
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendar),
            label: '시간표',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bowlFood),
            label: '식단표',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.usersRectangle),
            label: '상담',
          ),
        ],
      ),
    );
  }
}
