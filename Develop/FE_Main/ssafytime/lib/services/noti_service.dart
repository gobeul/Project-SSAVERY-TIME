import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

class NotiService extends GetxService {
  static NotiService get to => Get.find();

  FirebaseMessaging fcm = FirebaseMessaging.instance;

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() async {
    await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _onInit();
    _onMessage();
    super.onInit();
  }

  Future<void> _onInit() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/launcher_icon'),
            iOS: DarwinInitializationSettings(
                requestSoundPermission: true,
                requestBadgePermission: true,
                requestAlertPermission: true)),
        onDidReceiveNotificationResponse: (res) => {});
  }

  // local_notification 활용한 notification 알림
  void _onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      //   AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description),
            iOS: DarwinNotificationDetails(
              badgeNumber: 1,
              subtitle: 'the subtitle',
              sound: 'slow_spring_board.aiff',
            ),
          ),
        );
      }
      log('Message data: ${message.data}');
    });
  }

  Future<void> addAlarm(
      String title, DateTime time, List<DateTime> repeatDate) async {
    log("addAlarm : ${title} / ${time.toIso8601String()} / ${repeatDate.length}");
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    repeatDate.forEach((date) async {
      var scheduledDate = _setNotiTime(time, date);
      log("check add Alarm");
      int id = int.parse(date.month.toString() +
          date.day.toString() +
          date.hour.toString() +
          date.day.toString() +
          date.second.toString());
      flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          "알림",
          title,
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description),
            iOS: DarwinNotificationDetails(
              badgeNumber: 1,
              subtitle: 'the subtitle',
              sound: 'slow_spring_board.aiff',
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    });
  }

  Future<void> removeAlarm(List<DateTime> repeatDate) async {
    log("removeAlarm !!!!!");
    repeatDate.forEach((date) async {
      int id = int.parse(date.month.toString() +
          date.day.toString() +
          date.hour.toString() +
          date.day.toString() +
          date.second.toString());
      await flutterLocalNotificationsPlugin.cancel(id);
    });
  }

  tz.TZDateTime _setNotiTime(DateTime time, DateTime date) {
    // final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, date.year, date.month, date.day,
        time.hour, time.minute, time.second);
    log("${scheduledDate.toIso8601String()}");

    return scheduledDate;
  }
}
