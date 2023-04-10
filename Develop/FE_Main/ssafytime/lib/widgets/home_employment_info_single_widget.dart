import 'package:flutter/material.dart';
import 'package:ssafytime/models/recruitment.dart';

// 홈 스크린 채용정보 단일 위젯
class HEIS extends StatelessWidget {
  final recruitCompany info;

  const HEIS({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = info.company!;
    String detail = info.job!;
    String period = info.date!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      width: MediaQuery.of(context).size.width * ( 358 / 392.7),
      height: MediaQuery.of(context).size.height * ( 87 / 803),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              '모집분야 : ' + detail,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0x58000000)),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  period,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0x58000000)),
                ),
              ])
        ],
      ),
    );
  }
}
