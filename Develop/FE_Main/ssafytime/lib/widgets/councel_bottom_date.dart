import 'package:flutter/material.dart';

import 'councel_bottom_calender.dart';

class CBDate extends StatelessWidget {
  const CBDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * ( 390 / 392.7),
      height: MediaQuery.of(context).size.height * ( 94 / 803),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(height: 1, thickness: 2, color: Colors.grey,),
          SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),),
          Container(
            child: Text('상담 날짜', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),),
          ),
          Container(
            width: MediaQuery.of(context).size.width * ( 358 / 392.7),
            height: MediaQuery.of(context).size.height * ( 40 / 803),
            child: CBCalender(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),)
        ],
      ),
    );
  }
}

