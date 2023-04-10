import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:ssafytime/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ssafytime/repositories/user_repository.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final user = User().obs;
  final storage = const FlutterSecureStorage();
  final tokenState = 0.obs;
  final autoLogin = false.obs;
  bool isLogin = false;
  late UserRepo userApi;

  String _accessKey = "accessToken";
  String _refreshKey = "refreshToken";
  final accessToken = Rxn<String>(null);
  final refreshToken = Rxn<String>(null);
  @override
  void onInit() async {
    // await getToken();
    // await fetchToken();
    log("accessToken : $accessToken");
    log("refreshToken : $refreshToken");
    log("isLogin : $isLogin");
    super.onInit();
  }

  Future<void> getToken() async {
    var accessT = await storage.read(key: _accessKey);
    accessToken(accessT);
    var refreshT = await storage.read(key: _refreshKey);
    refreshToken(refreshT);
  }

  Future<void> login(String email, String password, bool? autoLoginFlag) async {
    try {
      var res = await http.post(
        Uri.parse("http://i8a602.p.ssafy.io:9090/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"userEmail": email, "password": password}),
        encoding: Encoding.getByName("utf-8"),
      );
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        accessToken(data['accessToken']);
        refreshToken(data['refreshToken']);
        if (autoLoginFlag ?? false) {
          await storage.write(key: _accessKey, value: accessToken.value);
          await storage.write(key: _refreshKey, value: refreshToken.value);
        }
        autoLogin(autoLoginFlag ?? false);
        isLogin = true;
        userApi = UserRepo(token: accessToken.value);
        tokenState.value = res.statusCode;
        Get.offAllNamed('/');
      } else if (res.statusCode == 401) {
        tokenState.value = res.statusCode;
      }
    } catch (e) {
      Get.snackbar("오류", "정보",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text("로그인 실패"),
          messageText: Text(e.toString()));
    }
  }

  void logout() async {
    await clearToken();
    accessToken(null);
    refreshToken(null);
    user(null);
    userApi.updateFcmToken(null);
    isLogin = false;

    Get.offAllNamed('/login');
  }

  Future<void> clearToken() async {
    await storage.delete(key: _accessKey);
    await storage.delete(key: _refreshKey);
  }

  Future<bool> fetchToken() async {
    if (accessToken.value != null && refreshToken.value != null) {
      var res = await http.post(
          Uri.parse("http://i8a602.p.ssafy.io:9090/refresh-token"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "accessToken": accessToken.value,
            "refreshToken": refreshToken.value
          }));
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        accessToken.value = data['accessToken'];
        refreshToken.value = data['refreshToken'];
        await storage.write(key: _accessKey, value: accessToken.value);
        await storage.write(key: _refreshKey, value: refreshToken.value);
        isLogin = true;
        userApi = UserRepo(token: accessToken.value);
        return true;
      }
    }
    return false;
  }
}
