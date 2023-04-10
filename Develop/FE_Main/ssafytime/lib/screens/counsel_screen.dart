// check and regist counsel screen

import 'package:flutter/material.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/councel_admin_councel.dart';

import '../widgets/councel_my_councel.dart';
import '../widgets/councel_bottom_total.dart';

class CounselScreen extends StatefulWidget {
  const CounselScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CounselScreenStates();
}

class _CounselScreenStates extends State<CounselScreen> {
  int userCode = AuthService.to.user.value.isAdmin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("상담"),
      ),
      floatingActionButton: _getFAB(),
      body: Container(
          color: Colors.white,
          child: userCode == 0 ? CMyCouncel() : CAdminCouncel()),
    );
  }

  // admin == 1 일때, 학생일때만 상담 신청 버튼이 있고 관리자는 없음
  Widget _getFAB() {
    if (AuthService.to.user.value.isAdmin != 0) {
      return SizedBox();
    } else {
      return FloatingActionButton(
        backgroundColor: Color(0xffD3E4FF),
        onPressed: () {
          openCouncelBottomSheet(context);
        },
        child: Icon(Icons.add, color: Color(0xff0079D1)),
      );
    }
  }
}
