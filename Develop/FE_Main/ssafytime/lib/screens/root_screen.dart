import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/bottom_navbar_controller.dart';
import 'package:ssafytime/screens/calendar_screen.dart';
import 'package:ssafytime/screens/counsel_screen.dart';
import 'package:ssafytime/screens/home_screen.dart';
import 'package:ssafytime/screens/menu_book_screen.dart';
import 'package:ssafytime/widgets/bottom_navbar.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);
  static List<Widget> tabPages = <Widget>[
    HomeScreen(),
    const CalendarScreen(),
    const MenuBookScreen(),
    const CounselScreen()
  ];
  @override
  Widget build(BuildContext context) {
    Get.put(BottomNavigationBarController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(content: Text("뒤로 가기를 한 번 더 누르시면 종료됩니다")),
        child: Obx(() => SafeArea(
            child:
                tabPages[BottomNavigationBarController.to.selectedIdx.value])),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
