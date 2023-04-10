import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  String content;
  int color;
  FontWeight fontWeight;
  double fontSize;


  CustomText({Key? key,
    this.content = 'content : 내용',
    this.color = 0xff000000,
    this.fontWeight =  FontWeight.w700,
    this.fontSize = 16,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(color: Color(color),
        fontWeight: fontWeight,
        fontSize : fontSize,
      ),
    );
  }
}
