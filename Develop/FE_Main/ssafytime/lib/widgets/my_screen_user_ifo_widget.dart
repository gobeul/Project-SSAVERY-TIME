import 'package:flutter/material.dart';

// 마이 스크린 사진 학번 있는 위젯
class MUI extends StatefulWidget {
  final String? imgURL;
  final int studentID;
  final String name;

  const MUI({
    Key? key,
    required this.name,
    this.imgURL,
    required this.studentID,
  }) : super(key: key);

  @override
  State<MUI> createState() => _MUIState();
}

class _MUIState extends State<MUI> {
  @override
  Widget build(BuildContext context) {
    String imgUrl = widget.imgURL ?? "assets/image/no_profile_image.png";
    String studentID = widget.studentID.toString();
    String name = widget.name;

    return Container(
      width: MediaQuery.of(context).size.width * ( 390 / 392.7),
      height: MediaQuery.of(context).size.height * ( 80 / 803),
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            child: FittedBox(
              fit: BoxFit.contain,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imgUrl),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * ( 10 / 392.7),
          ),
          Container(
              child: Text('${studentID} ${name}',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)))
        ],
      ),
    );
  }
}
