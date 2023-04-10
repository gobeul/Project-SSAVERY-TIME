// check all notification screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  NotificationController notiC = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text("알림"),
          bottom: TabBar(
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            labelColor: const Color(0xff3396F4),
            indicatorColor: const Color(0xff3396F4),
            controller: notiC.tabController,
            tabs: notiC.myTabs,
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  await notiC.fetchNotiList();
                },
                child: ListView(
                  children: notiC.notiListWidgets,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
