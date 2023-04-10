import 'package:flutter/material.dart';
import 'package:ssafytime/model/schedule_week.dart';

class ScSingleItem extends StatelessWidget {
  Map<int, List> coding = {
    0 : ['서버 점검', 0xff000000],
    1: ['코딩과정', 0xff686ADB],
    2: ['알고리즘', 0xff0082A1],
    3: ['프로젝트', 0xffDE3730],
    4: ['기타', 0xff0079D1],
  };

  Map<int, String> place = {0: '오프라인', 1: '온라인', 3: ''};

  Datum data;

  ScSingleItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String classPlace = place[data.onOff] ?? '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * ( 5 / 392.7),
          height: MediaQuery.of(context).size.height * ( 81 / 803),
          color: Color(coding[data.category]![1]), // option 1
        ),
        Container(
          width: MediaQuery.of(context).size.width * ( 353 / 392.7),
          height: MediaQuery.of(context).size.height * ( 81 / 803),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // option 2
                    Text(
                      coding[data.category]?[0] ?? '서버 점검',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: Color(coding[data.category]![1]), // option 1
                      ),
                    ),
                    // option 3
                    Text(
                      classPlace,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 8),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // option 4
                    Text(
                      data.title ?? '서버 점검 중 ...',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Color(0xff73777F),
                      ),
                    ),
                    SizedBox(height: 0,),
                    // option 5
                    Text(
                      data.subTitle ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LunchTimeTable extends StatelessWidget {
  const LunchTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * ( 5 / 392.7),
              height: MediaQuery.of(context).size.height * ( 81 / 803),
              color: Color(0xff93000A), // option 1
            ),
            Container(
                width: MediaQuery.of(context).size.width * ( 353 / 392.7),
                height: MediaQuery.of(context).size.height * ( 81 / 803),
                color: Colors.white,
                child: Center(
                    child: Text(
                  '중식',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ))),
          ],
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: Color(0xffC3C6CF),
        )
      ],
    );
  }
}

// 블랭크는 구분선크기를 포함 시키되 보이면 안되니깐 컨테이너 자체 크기를 +1 해줌
class BlankTimeTable extends StatelessWidget {
  Map<int, int> colorList = {
    0: 0xff000000,
    1: 0xff686ADB,
    2: 0xff0082A1,
    3: 0xffDE3730,
    4: 0xff0079D1,
  };

  int color;

  BlankTimeTable({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 0, color: Colors.white)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * ( 5 / 392.7),
              height: MediaQuery.of(context).size.height * ( 82 / 803),
            color: Color(colorList[color] ?? 0xff000000)
          ),
          Container(
            width: MediaQuery.of(context).size.width * ( 353 / 392.7),
            height: MediaQuery.of(context).size.height * ( 82 / 803),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
