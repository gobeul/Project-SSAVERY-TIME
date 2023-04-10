import 'package:flutter/material.dart';


class CustomElevatedButton extends StatelessWidget {

  double width;
  double height;
  VoidCallback onPressed;
  int color;
  int borderColor;
  int labelColor;
  double radius;
  double borderWidth;
  double fontSize;
  String label;


  CustomElevatedButton({Key? key,
    required this.onPressed,
    this.width = 100,
    this.height = 50,
    this.color = 0xffFFFFFF,
    this.borderColor = 0xff000000,
    this.labelColor = 0xff000000,
    this.radius = 10.0,
    this.borderWidth = 1.0,
    this.label = '버튼',
    this.fontSize = 15.0,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            width: borderWidth,
            color: Color(borderColor)
          ),
          backgroundColor: Color(color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          )
        ),

        child: Text(label,
          style: TextStyle(
            color: Color(labelColor),
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
