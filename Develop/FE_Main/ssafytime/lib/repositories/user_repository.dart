import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:ssafytime/models/user_model.dart';

class UserRepo {
  String? token;
  Map<String, String>? headers;
  String baseUrl = "http://i8a602.p.ssafy.io:9090/user";
  String vapiKey =
      "BKEyfl55H2kgfEnSwt3yqPp9CwLtf9Ntgwv13RiT-U-jjzrozda7WadN2v6Z4Cl6x4_dOxHLMdeh3rfKjiL2YTM";

  UserRepo({this.token}) {
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token}"
    };
  }

  Future<User?> fetchUserInfo() async {
    var res = await http.get(Uri.parse("${baseUrl}/my-page"), headers: headers);
    log("fetchUserInfo status : ${res.statusCode}");
    if (res.statusCode == 200) {
      return User.fromRawJson(res.body);
    } else {
      return null;
    }
  }

  Future<String?> fetchFcmToken() async {
    return await FirebaseMessaging.instance.getToken(vapidKey: vapiKey);
  }

  Future<bool> updateFcmToken(String? fcmToken) async {
    var res = await http.post(Uri.parse(baseUrl + "/alarm"),
        headers: headers, body: json.encode({"fcmtoken": fcmToken}));
    log("${res.statusCode}");

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
