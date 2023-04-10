import 'package:flutter/material.dart';

// 메뉴북 스크린 단일 위젯
class MIW extends StatefulWidget {

  final String imgUrl;
  final String mainMenu;
  final List subMenuList; // 서브 메뉴이름(String)을 원소로하는 리스트
  final int foodKcal;

  const MIW({Key? key,
    required this.imgUrl,
    required this.foodKcal,
    required this.mainMenu,
    required this.subMenuList}) : super(key: key);

  @override
  State<MIW> createState() => _MIWState();
}

class _MIWState extends State<MIW> {
  @override
  Widget build(BuildContext context) {

    String imgUrl = widget.imgUrl;
    String mainMenu = widget.mainMenu;
    List subMenuList = widget.subMenuList;
    int foodKcal = widget.foodKcal;

    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * ( 358 / 392.7),
      height: MediaQuery.of(context).size.height * ( 180 / 803),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2, color: Colors.blue),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5.0,
            offset: Offset(0.0, 4)
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * ( 179 / 392.7),
            height: MediaQuery.of(context).size.height * ( 163 / 803),
            margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
            decoration: BoxDecoration(
              color: Color(0x08000000),
              border: Border.all(width: 2, color: Color(0x05000000)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: imgUrl != '' ? Image.network(imgUrl, fit: BoxFit.contain)
            : Image.asset('assets/image/no_menu.png', fit:BoxFit.contain),
          ),
          Container(
            width: MediaQuery.of(context).size.width * ( 162 / 392.7),
            height: MediaQuery.of(context).size.height * ( 155 / 803),
            padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // option2 mainMenu
                Text(mainMenu,
                  style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w900),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * ( 5 / 803),),
                Container(
                  width: MediaQuery.of(context).size.width * ( 146 / 392.7),
                  height: MediaQuery.of(context).size.height * ( 58 / 803),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // option3 subMenuList
                        for (int i = 0; i < subMenuList.length; i++)
                          Text(subMenuList[i],
                            style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.black54),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * ( 146 / 392.7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * ( 10 / 803),
                      ),
                      Text('1타에 xx칼로리 소모!!',
                        style: TextStyle(fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * ( 5 / 803),
                      ),
                      // option4 foodKcal
                      Text(foodKcal.toString() + 'Kcal',
                        style: TextStyle(fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.black26),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


