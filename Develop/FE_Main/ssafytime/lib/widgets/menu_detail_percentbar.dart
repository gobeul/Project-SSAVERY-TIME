import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:ssafytime/widgets/custom_text.dart';

class MDetailPercentBar extends StatelessWidget {
  
  final String title;
  final int amount; // 현재 양
  final int total;
  final String unit; // 단위

  
  const MDetailPercentBar({Key? key,
    this.title = 'no data',
    this.amount = 0,
    this.total = 1000,
    this.unit = 'g'
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * ( 63 / 392.7),
      height: MediaQuery.of(context).size.height * ( 190 / 803),
      child: Column(
        children: [
          CustomText(content: title, fontSize: 11,),
          SizedBox(height: MediaQuery.of(context).size.height * ( 4 / 803),),
          Container(
            width: MediaQuery.of(context).size.width * ( 20 / 392.7),
            height: MediaQuery.of(context).size.height * ( 150 / 803),
            child: FAProgressBar(
              direction: Axis.vertical,
              verticalDirection: VerticalDirection.up,
              animatedDuration: Duration(milliseconds: 1000),
              backgroundColor: Color(0xffD6D6D6),
              currentValue: (amount*100 ~/ total).toDouble(),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * ( 4 / 803),),
          CustomText(content: '${amount}${unit}', fontSize: 10,)
        ],
      ),
    );
  }
}


// 영양 성분 테이블
class NutritionTable {
  // 탄 단 지 = 45 : 15 : 40
  // 하루 2200kcal 섭취 기준 = 990 330 880 -> 248g : 83g : 220g
  // 나트륨 3000mg 기준
  Map table = {
    'cho' : 248,
    'pro' : 83,
    'fat' : 97,
    'salt' : 3000,
    'kcal' : 2200,
  };

  double getPercent(int value, int total) {
    return (value / total)*100;
  }

}