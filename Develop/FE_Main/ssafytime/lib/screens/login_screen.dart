// login screen
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ssafytime/services/auth_service.dart';
import 'package:ssafytime/widgets/login_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassWord = TextEditingController();

  bool? autoLoginFlag = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  // width: 50,
                  width: MediaQuery.of(context).size.width * (50 / 392.7),
                  // height: 100,
                  height: MediaQuery.of(context).size.height * (100 / 803),
                ),
                Container(
                  // width: 200,
                  width: MediaQuery.of(context).size.width * (200 / 392.7),
                  // height: 200,
                  height: MediaQuery.of(context).size.height * (200 / 803),
                  color: Colors.white,
                  child: Image.asset('assets/image/ssafytime_Icon.png'),
                ), // 앱 로고
                Form(
                    child: Column(
                  children: [
                    CustomInputData(
                      userInfo: userEmail,
                      labelText: '이메일',
                      placeholderText: '이메일을 입력해 주세요.',
                      inputType: TextInputType.emailAddress,
                      isObscureText: false,
                    ),
                    SizedBox(
                      // height: 15,
                      height: MediaQuery.of(context).size.height * (15 / 803),
                    ),

                    CustomInputData(
                      userInfo: userPassWord,
                      labelText: '비밀번호',
                      placeholderText: '비밀번호를 입력해 주세요.',
                      inputType: TextInputType.text,
                      isObscureText: true,
                    ),
                    SizedBox(
                      // height: 40,
                      height: MediaQuery.of(context).size.height * (40 / 803),
                    ),
                    ElevatedButton(
                      /// toDo : 로그인 기능 구현 ///
                      onPressed: () async {
                        log("${userEmail.text} / ${userPassWord.text}");
                        await AuthService.to.login(
                            userEmail.text, userPassWord.text, autoLoginFlag);
                        log("{AuthService.to.isLogin}");
                        if (AuthService.to.isLogin == false) {
                          wrongUserInfo(context, '아이디와 비밀번호를 확인해 주세요.', 2);
                        }
                        //   Get.offAllNamed('/');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * (330 / 392.7),
                              MediaQuery.of(context).size.height * (60 / 803)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ///////////////자동 로그인 및 비밀번호 찾기///////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 30)),
                            Checkbox(
                                value: autoLoginFlag,
                                onChanged: (value) {
                                  setState(() {
                                    autoLoginFlag = value;
                                  });
                                  log("autoCheck : ${autoLoginFlag}");
                                }),
                            const Text(
                              '자동로그인',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextButton(

                              /// toDo : 비밀번호 찾기 기능 구현 //
                              onPressed: () {},
                              child: const Text(
                                '비밀번호 찾기',
                                style: TextStyle(fontSize: 15),
                              )),
                        )
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 이메일 or 비번 오류시에 스낵바로 표현
// 함수 인자 context 는 변경 ㄴㄴ
// erroMsg 에는 출력할 에러 메세지 작성
// sec 는 몇 초 동안 스백바 를 띄울  것인지
void wrongUserInfo(BuildContext context, String errorMsg, int sec) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMsg), // 띄울 에러 메세지
      duration: Duration(seconds: sec), // 몇 초 동안 띄울 것인가
      backgroundColor: Colors.red,
    ),
  );
}
