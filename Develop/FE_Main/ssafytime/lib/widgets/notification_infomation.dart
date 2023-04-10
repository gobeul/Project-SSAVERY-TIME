import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// CNI = CustomNotificationInfomation 커스텀 알림 정보
class CNI extends StatefulWidget {
  final double opacity; // 미완료(1), 완료(0.4)
  final IconData myIcon; // 넣을 아이콘
  // 공지 : FontAwesomeIcons.bullhorn,
  // 설문 : FontAwesomeIcons.pen,
  // 상담 : FontAwesomeIcons.userGroup

  final int iconColor; // 아이콘 색상
  // 공지 : 0xffFF5449
  // 설문 : 0xff0079D1
  // 상담 : 0xff686ADB

  final String title; // 제목
  final Widget detail; // 세부사항 기간 이나 프로그래스바
  final String isComplete; // 진행, 완료, ""(none)
  // 기간 예시 Container(child: Text('23.01.01 ~ 23.01.02'))

  const CNI(
      {Key? key,
      required this.opacity,
      required this.myIcon,
      required this.iconColor,
      required this.title,
      required this.detail,
      required this.isComplete})
      : super(key: key);

  @override
  State<CNI> createState() => _CNIState();
}

class _CNIState extends State<CNI> {
  @override
  Widget build(BuildContext context) {
    double opacity = widget.opacity;
    IconData myIcon = widget.myIcon;
    int iconColor = widget.iconColor;
    String title = widget.title;
    Widget detail = widget.detail;
    String isComplete = widget.isComplete;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * ( 358 / 392.7),
          height: MediaQuery.of(context).size.height * ( 62 / 803),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: opacity,
                child: Row(
                  children: [
                    // 아이콘 컨네이너
                    Container(
                        width : MediaQuery.of(context).size.width * ( 50 / 392.7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(iconColor), width: 2),
                        ),
                        // option 아이콘 모양, 색상
                        child: Center(
                            child: FaIcon(
                          myIcon,
                          size: 20,
                          color: Color(iconColor),
                        ))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * ( 15 / 392.7),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // option 제목
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            title,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                        ),
                        // option 기간이나 진행바
                        detail
                      ],
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: opacity,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    isComplete, // optional 완료, 예정, (none)
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
