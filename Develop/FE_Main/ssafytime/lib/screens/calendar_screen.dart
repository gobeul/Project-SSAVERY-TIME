// check calendar screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssafytime/widgets/schedule_day_of_week.dart';
import 'package:ssafytime/controllers/loading_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("시간표"),
      ),
      body: Stack(
        children: [
          SizedBox(
            child: Column(
              children: [
                SDay0fWeek(),
              ],
            ),
          ),
          Obx(() => Offstage(
              offstage: !loadingController.to.isLoading,
              child: Center(
                child: Container(
                  color: Color(0x50000000),
                  width: double.infinity, height: double.infinity,
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              )))
        ],
      ),
    );
  }
}
