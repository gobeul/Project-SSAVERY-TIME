import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ssafytime/controllers/home_time_controller.dart';


class HScheduleItem extends StatelessWidget {

  HomeTimeController _controller = Get.find<HomeTimeController>();

  HScheduleItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * ( 5 / 392.7),
            height: MediaQuery.of(context).size.height * ( 160 / 803),
            color: Color(_controller.color.value), // option 1
          ),
          Container(
            width: MediaQuery.of(context).size.width * ( 360 / 392.7),
            height: MediaQuery.of(context).size.height * ( 160 / 803),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // option 2
                      Text(
                        _controller.category.value,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Color(_controller.color.value), // option 1
                        ),
                      ),
                      // option 3
                      Text(
                        _controller.onoff.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // option 4
                      Text(
                        _controller.title.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Color(0xff73777F),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // option 5
                      Text(
                        _controller.subTitle.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 28),
                      ),
                    ],
                  ),
                ),
                // option 7 수업 중이냐 전이냐
                Column(
                  children: [
                    // 수업중
                    if (_controller.isClassTime.value == true)
                      Column(
                        children: [
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width * ( 350 / 392.7),
                            lineHeight: 8,
                            barRadius: const Radius.circular(4),
                            percent: _controller.percent.value, // optinal 6_1
                            progressColor: const Color(0xffFC6161),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // option 6
                              Text(
                                _controller.classTime.value,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xffABABAE),
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * ( 16 / 392.7),
                              ),
                            ],
                          ),
                        ],
                      ),
                    // 수업 전 ============
                    if (_controller.isClassTime.value == false && _controller.category.value != '')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // option 6
                          Text(
                            _controller.classTime.value,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffABABAE),
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * ( 16 / 392.7),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

