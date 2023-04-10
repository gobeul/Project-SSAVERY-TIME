import 'package:get/get.dart';
import 'package:ssafytime/controllers/home_time_controller.dart';
import 'package:ssafytime/controllers/notification_controller.dart';
import 'package:ssafytime/controllers/schedule_week_controller.dart';
import 'package:ssafytime/controllers/user_state_controller.dart';
import 'package:ssafytime/controllers/user_controller.dart';
import 'package:ssafytime/screens/counsel_screen.dart';
import 'package:ssafytime/screens/login_screen.dart';
import 'package:ssafytime/screens/notification_screen.dart';
import 'package:ssafytime/screens/root_screen.dart';
import 'package:ssafytime/screens/survey_screen.dart';
import 'package:ssafytime/screens/user_screen.dart';
import 'package:ssafytime/utils/auth_guard.dart';

class AppRoutes {
  static String inital = '/';
  static List<GetPage> routes = [
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
    ),
    GetPage(
      middlewares: [AuthGuard()],
      name: '/',
      page: () => RootScreen(),
      binding: BindingsBuilder(() {
        Get.put(
          UserController(),
        );
        Get.put(HomeTimeController());
        Get.put(SchedulePickDayController());
        // UserController.to.initFetch();
      }),
    ),
    GetPage(
      middlewares: [AuthGuard()],
      name: '/userPage',
      page: () => UserScreen(),
      binding: BindingsBuilder(() {
        UserController.to.fetchAttence();
        Get.put(UserStateController());
      }),
    ),
    GetPage(
      name: '/notification',
      page: () => NotificationScreen(),
      binding: BindingsBuilder(() {
        Get.put(NotificationController());
      }),
    ),
    GetPage(
        middlewares: [AuthGuard()],
        name: '/userPage',
        page: () => UserScreen()),
    GetPage(name: '/survey', page: () => SurveyScreen()),
    GetPage(name: '/CouncelPage', page: () => CounselScreen()),
  ];
}
