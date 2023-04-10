import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/home_time_controller.dart';
import 'package:ssafytime/model/home_menu.dart';

class HTodayMenuTotal extends StatelessWidget {

  HomeTimeController _controller = Get.find<HomeTimeController>();

  HTodayMenuTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: MediaQuery.of(context).size.width * ( 360 / 392.7),
        height: MediaQuery.of(context).size.height * ( 251 / 803),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i=0; i < _controller.todayMenu.data!.length; i++) ... [
              HTodayMenuItem(
                data: _controller.todayMenu.data![i],
              ),
              SizedBox(width: 10,)
            ],
          ],
        ),
      )
    );
  }
}








class HTodayMenuItem extends StatelessWidget {

  Datum data;

  HTodayMenuItem({Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 173,
        height: 211,
        color: Colors.white,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(15),
        //     border: Border.all(width: 2),
        //     color: Colors.white
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                data.imageUrl,
                fit: BoxFit.fill, // option1
                width: 173, height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // option2-1
                  Text(
                    data.mainMenu,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 16),
                  ),

                  // 사이드 메뉴, 공간상 2 개까지만
                  for (int i = 0; i < min(2, data.sideMenu.length); i++) ... [
                    Text(
                      i == 0 ? data.sideMenu[i] : '${data.sideMenu[i]}...',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: Color(0xff73777F),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 5,
                  ),
                  // option 3
                  Text(
                    '${data.kcal}kcal',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
