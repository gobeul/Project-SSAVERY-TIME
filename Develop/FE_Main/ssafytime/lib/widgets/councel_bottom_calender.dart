import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/councel_controller.dart';


class CBCalender extends StatelessWidget {

  CBCalender({Key? key}) : super(key: key);

  MyCouncelController controller = Get.find<MyCouncelController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(controller.myPickDateDisplay.value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                // 하루 뒤 부터 예약가능
                // initialDate: DateTime.now().add(Duration(hours: 24)),
                // firstDate: DateTime.now().add(Duration(hours: 24)),
                // lastDate: DateTime.now().add(Duration(hours: 720)),

                // 일단 선택 범위 없애고
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd-EE').format(pickedDate);
                List<String> formatDateList = formattedDate.split('-');
                controller.selectDateAndFetchReservation(formatDateList);
              }
            },
            child: Text('날짜 선택',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: Color(0xff73777F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
