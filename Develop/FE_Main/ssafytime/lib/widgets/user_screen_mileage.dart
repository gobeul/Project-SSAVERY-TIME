import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 마이 스크린 마일리지 위젯
class MMileage extends StatefulWidget {
  int? myMileage;

  MMileage({Key? key, this.myMileage}) : super(key: key);

  @override
  State<MMileage> createState() => _MMileageState();
}

class _MMileageState extends State<MMileage> {
  final f = NumberFormat("###,###,###,###");
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * ( 390 / 392.7),
      height: MediaQuery.of(context).size.height * ( 72 / 803),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '마일리지',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  f.format(widget.myMileage ?? 0),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * ( 8 / 392.7),
                ),
                Text(
                  '마일리지',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// int 30000 -> String 30,000 이렇게 바꾸는 함수
String convertMileage(int? money) {
  List tmp = money.toString().split("");
  String res = '';
  int cnt = 1;
  for (int i = tmp.length - 1; i > -1; i--) {
    if (cnt > 1 && cnt % 3 == 1) {
      res = ',' + res;
    }
    res = tmp[i] + res;
    cnt++;
  }

  return res;
}
