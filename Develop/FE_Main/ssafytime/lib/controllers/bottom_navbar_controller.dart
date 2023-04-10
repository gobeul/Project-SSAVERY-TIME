import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController {
  static BottomNavigationBarController get to => Get.find();

  final RxInt selectedIdx = 0.obs;

  void changeIdx(int idx) {
    selectedIdx(idx);
  }
}
