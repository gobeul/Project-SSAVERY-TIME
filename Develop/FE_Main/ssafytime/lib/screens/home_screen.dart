// main screen

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/schedule_week_controller.dart';
import 'package:ssafytime/controllers/user_controller.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/home_attendance_state_widget.dart';
import 'package:ssafytime/widgets/home_employment_info_total_widget.dart';
import 'package:ssafytime/widgets/home_menu_item_v2.dart';
import 'package:ssafytime/widgets/home_schedule_item_v2.dart';

import '../controllers/home_time_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

//   final UserController userC = Get.find<UserController>();
  HomeTimeController homeTimeController = Get.find<HomeTimeController>();
  SchedulePickDayController controller = Get.find<SchedulePickDayController>();

  @override
  State<StatefulWidget> createState() => _HomeScreenStates();
}

class _HomeScreenStates extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserController userC = Get.find<UserController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
              "${AuthService.to.user.value.userIdx} ${AuthService.to.user.value.userName}"),
          actions: <Widget>[
            IconButton(
              onPressed: () => Get.toNamed('/userPage'),
              icon: const FaIcon(
                FontAwesomeIcons.user,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () => Get.toNamed('/notification'),
              icon: const FaIcon(
                FontAwesomeIcons.bell,
                size: 20,
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(
                () => HA(
                    absent: userC.userAtten.value.absentO,
                    attendance: userC.userAtten.value.attenN,
                    tardy: userC.userAtten.value.lateO,
                    imgURL: AuthService.to.user.value.userImg),
              ),
              // CarouselSlider =========================================
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                color: Colors.white,
                child: CarouselSlider(
                  disableGesture:
                      userC.carouselItemList.length > 1 ? true : false,
                  items: userC.carouselItemListWidget,
                  options: CarouselOptions(
                    // height: 68,
                    height: MediaQuery.of(context).size.height * (68 / 803),
                    viewportFraction: 1,
                    autoPlay: userC.carouselItemList.length > 1 ? true : false,
                    enableInfiniteScroll:
                        userC.carouselItemList.length > 1 ? true : false,
                    autoPlayInterval: const Duration(seconds: 5),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        widget.homeTimeController.isLunch != true
                            ? "시간표"
                            : '점심메뉴',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (widget.homeTimeController.isLunch != true) ...[
                      HScheduleItem(),
                    ] else ...[
                      HTodayMenuTotal(),
                    ]
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  width: double.infinity,
                  color: Colors.white,
                  child: HEIT(),
                ),
              ),
              Divider(
                height: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
