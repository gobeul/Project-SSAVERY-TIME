import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ssafytime/custom_button.dart';
import 'package:ssafytime/screens/call_counsel.dart';
import 'package:ssafytime/services/auth_service.dart';

class CouncelListItem extends StatelessWidget {

  final String title; // 제목

  double currentTime; // 현재시간 202302061530.0 이런 형태로 들어옴
  double startTime; // 시작 시간
  double endTime; // 끝나는 시간

  double rezTime; // 13.5 이런값 api에서 받는 값
  String? reject;
  int state;

  String? sessionId;
  String? name = AuthService.to.user.value.userName;

  int rezIdx;

  CouncelListItem({
    Key? key,
    required this.title,
    required this.currentTime,
    required this.startTime,
    required this.endTime,
    required this.rezTime,
    required this.reject,
    required this.state,
    required this.sessionId,
    required this.rezIdx
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String councelTime = CItemCouncelTime(rezTime); // 13:00 ~ 14:00
    String councelDate = CItemDate(startTime);
    double opacity = (state == 3 || state == 4) ? 0.4 : 1;
    return InkWell(
      onTap: () {
        if (state == 2) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: (startTime <= currentTime && currentTime <= endTime) ? 
                    Text(sessionId != null ?'방에 접속해주세요!' : '승인 처리 중 ...') :
                      Text('상담시간을 확인해 주세요.')
                ),

                content: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (sessionId != null && startTime <= currentTime && currentTime <= endTime) ... [
                        CustomElevatedButton(
                            label: '상담',
                            color: 0xff3094F2,
                            labelColor: 0xffFFFFFF,
                            borderColor: 0xff3094F2,
                            onPressed: () async {
                              Get.off(() => CallCounsel(sessionName: sessionId ?? '', userName: name ?? '', rezIdx: rezIdx));
                            }
                        ),
                      ],
                      // 닫기
                      CustomElevatedButton(
                        label: '닫기',
                        onPressed: () {
                          Get.back();
                        }
                      ),
                    ],
                  )
                ),
              );
            },
          );
        }
      },
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * ( 358 / 392.7),
        height: MediaQuery.of(context).size.height * ( 62 / 803),
        child: Opacity(
          opacity: opacity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 아이콘 컨네이너
              Row(
                children: [
                  Container(
                      // width: 50,
                    width: MediaQuery.of(context).size.width * ( 50 / 392.7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xff686ADB), width: 2),
                      ),
                      // option 아이콘 모양, 색상
                      child: Center(
                          child: FaIcon(
                        FontAwesomeIcons.userGroup,
                        size: 20,
                        color: Color(0xff686ADB),
                      ))),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * ( 15 / 392.7),
                  ),
                ],
              ),
              Container(
                // 진행바가 있는경우는 290 , 없는 경우는 230
                width: (state == 2 &&
                        startTime <= currentTime &&
                        currentTime <= endTime)
                    ? MediaQuery.of(context).size.width * ( 290 / 392.7) //290
                    : MediaQuery.of(context).size.width * ( 230 / 392.7), //230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // option 제목
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900),
                    ),

                    // 시작 전 이라면 reject == null  : 승인 되었다.
                    // state 1 or state 2
                    if ((currentTime < startTime && reject == null) || state == 1) ...[
                      Row(
                        children: [
                          // option 6
                          Text(
                            councelDate + ' ' + councelTime,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffABABAE),
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * ( 16 / 392.7),
                          ),
                        ],
                      ),
                    ],
                    // 진행 중이라면
                    if (startTime <= currentTime &&
                        currentTime <= endTime &&
                        (state == 2)) ...[
                      Container(
                        child: CItemIng(
                          currentTime: currentTime,
                          endTime: endTime,
                          rezTime: rezTime,
                          startTime: startTime,
                        ),
                      )
                    ],

                    // 끝났다면 형태는 시작 전하고 같음
                    if (currentTime > endTime || reject != null) ...[
                      Container(
                        child: Row(
                          children: [
                            Text(
                              councelDate + ' ' + councelTime,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xffABABAE),
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * ( 16 / 392.7),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (state == 3 || state == 4) ...[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    state == 3 ? '반려' : '종료',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  ),
                )
              ] else if (!(startTime <= currentTime &&
                  currentTime <= endTime) || state == 1) ...[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    state == 1 ? '대기' : '승인',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// 진행 중일때 나타위젯 프로그래스바 있는거
class CItemIng extends StatelessWidget {
  double currentTime; // 현재시간 202302061530.0 이런 형태로 들어옴
  double startTime; // 시작 시간
  double endTime; // 끝나는 시간

  double rezTime; // 시작 시간 13.5 이런 형태

  CItemIng({
    Key? key,
    required this.currentTime,
    required this.startTime,
    required this.endTime,
    required this.rezTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double persent = CItemPersent(currentTime, rezTime);
    String councelTime = CItemCouncelTime(rezTime); // 13:00 ~ 14:00
    return Container(
      width: MediaQuery.of(context).size.width * ( 280 / 392.7),
      child: Column(
        children: [
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8,
            barRadius: const Radius.circular(4),
            percent: persent, // optinal 6_1
            progressColor: const Color(0xffFC6161),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // option 6
              Text(
                councelTime,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xffABABAE),
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 스트링으로 날짜 뽑기 2023-02-06
String CItemDate(double startTime) {
  String v = '';
  String tmp = startTime.toInt().toInt().toString();
  String y = tmp.substring(0, 4);
  String m = tmp.substring(4, 6);
  String d = tmp.substring(6, 8);

  v = '${y}-${m}-${d}';
  return v;
}

// rezTime 을 받아서 13:00 ~ 14:00 이렇게 바꿔주기
String CItemCouncelTime(double rezTime) {
  int sh = rezTime.toInt(); // 시작 시간
  int eh = sh + 1; // 종료 시간
  int m = ((rezTime - sh) * 60).toInt(); // 분
  String min = '00';
  if (m > 0) {
    min = '30';
  }

  return '${sh}:${min} ~ ${eh}:${min}';
}

// 얼마나 지났는지 퍼센트 구하기
double CItemPersent(double currentTime, double rezTime) {
  int sh = rezTime.toInt(); // 시작 시간
  int m = ((rezTime - sh) * 60).toInt(); // 분
  int exRezTime = sh * 60 + m; // 분으로 환산한 rezTime

  // 현재 시간 계산
  // currentTime = 202302061530.0;
  String b = currentTime.toInt().toInt().toString().substring(8, 10); // 시간
  String c = currentTime.toInt().toInt().toString().substring(10, 12); // 분
  int ch = int.parse(b) * 60; // 시간을 분으로 맞춰주기
  int cm = int.parse(c);
  int exCurrentTime = ch + cm; // 분으로 환산한 currentTime

  return (exCurrentTime - exRezTime) / 60;
}
