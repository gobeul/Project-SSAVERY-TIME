import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:ssafytime/controllers/loading_controller.dart';
import 'package:ssafytime/firebase_options.dart';
import 'package:ssafytime/services/auth_service.dart';

import 'package:ssafytime/services/noti_service.dart';
import 'package:ssafytime/utils/routes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Get.put(AuthService());
  await AuthService.to.getToken();
  await AuthService.to.fetchToken();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(loadingController()); // Loading indicator controller
  Get.put(NotiService());
  runApp(const SSAFYTIME());
}

class SSAFYTIME extends StatefulWidget {
  const SSAFYTIME({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SSAFYTIME();
}

class _SSAFYTIME extends State<SSAFYTIME> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return GetMaterialApp(
      title: 'SSAFY TIME',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
      builder: (context, child) {
        // 디바이스의 글자 크기 설정 무시
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      initialRoute: AppRoutes.inital,
      getPages: AppRoutes.routes,
      initialBinding: BindingsBuilder(() {}),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
