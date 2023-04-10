import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/councel_controller.dart';
import '../model/councel_bottom.dart';

class CBCategoryTotal extends StatefulWidget {
  CBCategoryTotal({Key? key}) : super(key: key);

  @override
  State<CBCategoryTotal> createState() => _CBCategoryTotalState();
}

class _CBCategoryTotalState extends State<CBCategoryTotal> {
  TextEditingController textController = TextEditingController();

  MyCouncelController controller = Get.find<MyCouncelController>();

  @override
  Widget build(BuildContext context) {
    staticCategory table = staticCategory();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * ( 390 / 392.7),
          height: MediaQuery.of(context).size.height * ( 64 / 803),
          child: TextField(
            style: TextStyle(fontSize: 16, color: Color(0xff262626),
                fontWeight: FontWeight.bold),
            controller: textController, // 유저가 입력한 비밀번호
            decoration: InputDecoration(
              label: Text('카테고리를 입력하세요.',
                style: TextStyle(
                  color: Color(0x40000000),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            onChanged: (textController) {
              controller.myInputCategory.value = textController;
            },
          ),
        ),
        Container(
          child: Text('ex) 취업, BE, FE, 알고리즘 등',
            style: TextStyle(fontWeight: FontWeight.w900,
              fontSize: 10, color: Colors.black54
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * ( 20 / 803),),

      ],
    );
  }
}
