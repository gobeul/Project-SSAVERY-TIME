import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TestCalender extends StatefulWidget {

  TestCalender({Key? key}) : super(key: key);

  @override
  State<TestCalender> createState() => _TestCalenderState();
}

class _TestCalenderState extends State<TestCalender> {

  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(controller: dateController,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          labelText: '날짜 선택해라.'
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat().format(pickedDate);
            setState(() {
              // dateController.text = pickedDate.toString();
              dateController.text = formattedDate;
            });
          } else {
            print('날짜선택 안함');
          }
        },
      ),
    );
  }
}


class DateController extends GetxController {
  var text = "".obs;

  @override
  void onInit() {
    super.onInit();
    text.value = "";
  }
}
