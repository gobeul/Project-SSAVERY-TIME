import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/councel_controller.dart';


class CBInputTitle extends StatefulWidget {
  CBInputTitle({Key? key}) : super(key: key);

  @override
  State<CBInputTitle> createState() => _CBInputTitleState();
}

class _CBInputTitleState extends State<CBInputTitle> {
  TextEditingController textController = TextEditingController();

  MyCouncelController controller = Get.find<MyCouncelController>();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, thickness: 2, color: Colors.grey,),
        SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * ( 390 / 392.7),
          height: MediaQuery.of(context).size.height * ( 64 / 803),
          child: TextField(
            style: TextStyle(fontSize: 16, color: Color(0xff262626),
                fontWeight: FontWeight.bold),
            controller: textController,
            decoration: InputDecoration(
              label: Text('상담제목',
                style: TextStyle(
                color: Color(0x40000000),
                fontWeight: FontWeight.w900,
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            onChanged: (textController) {
              controller.myInputTitle.value = textController;
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),),
      ],
    );
  }
}
