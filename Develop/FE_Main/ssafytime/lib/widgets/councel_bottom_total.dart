import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ssafytime/controllers/councel_controller.dart';

import '../custom_button.dart';
import 'councel_bottom_counselor_total.dart';
import 'councel_bottom_input_category.dart';
import 'councel_bottom_date.dart';
import 'councel_bottom_input_title.dart';
import 'councel_bottom_time_total.dart';




void openCouncelBottomSheet(BuildContext context) {
    MyCouncelController controller = Get.find<MyCouncelController>();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0)
          )
        ),
        builder: (BuildContext context) {
        return Obx(() => GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0)
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Text('상담신청', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      ),
                      CBCouncelorTotal(),
                      SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),),

                      // 관리자가 선택 되어야 낳짜를 선택할 수 있다.
                      controller.myPickCouncelor.value != 0 ?
                      CBDate() : SizedBox(), // 날짜 선택

                      // 날짜가 선택되어야 시간을 선택할 수 있다.
                      (controller.myPickDateDisplay.value != '') ?
                      CBTimeTotal() : SizedBox(), // 시간 선택

                      // 시간을 선택하고 나면 제목과 카테고리를 입력할 수 있다.
                      (controller.myPickTime.value != '') ?
                      CBInputTitle() : SizedBox(), // 내용 입력
                      (controller.myPickTime.value != '') ?
                      CBCategoryTotal() : SizedBox(), // 카테고리 입력

                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * ( 390 / 392.7),
                        height: MediaQuery.of(context).size.height * ( 47 / 803),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              width: MediaQuery.of(context).size.width * ( 171 / 392.7),
                              height: MediaQuery.of(context).size.height * ( 40 / 803),
                              label: '닫기',
                            ),
                            if (controller.myInputTitle.value != '' && controller.myInputCategory.value != '')
                              CustomElevatedButton(
                                onPressed: () {
                                  controller.submitCouncelApplication();
                                  Get.back();
                                },
                                color: 0xff3094F2,
                                width: MediaQuery.of(context).size.width * ( 171 / 392.7),
                                height: MediaQuery.of(context).size.height * ( 40 / 803),
                                label: '제출',
                                labelColor: 0xffFFFFFF,
                              ),
                            if (controller.myInputTitle.value == '' || controller.myInputCategory.value == '')
                              CustomElevatedButton(
                                onPressed: () {
                                  print('제출 내용 부족');
                                },
                                color: 0xffD9D9D9,
                                width: MediaQuery.of(context).size.width * ( 171 / 392.7),
                                height: MediaQuery.of(context).size.height * ( 40 / 803),
                                label: '제출',
                                labelColor: 0xffFFFFFF,
                              ),
                          ],
                        ),

                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    ).whenComplete(() => resetApplyData());
}

void resetApplyData() {
  MyCouncelController controller = Get.find<MyCouncelController>();
  controller.myPickCouncelor.value = 0;
  controller.myPickDateDisplay.value = '';
  controller.myPickDateServe.value = '';
  controller.myPickTime.value = '';
  controller.myInputTitle.value = '';
  controller.myInputCategory.value = '';
}
