import 'package:get/get.dart';

// 비동기 처리시에 로딩 애니메이션 보여주기 위함
class loadingController extends GetxController {
  static loadingController get to =>  Get.find();

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  void setIsLoading(bool value) => _isLoading.value = value;
}


