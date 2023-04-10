import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ssafytime/widgets/custom_text.dart';
import 'package:ssafytime/widgets/menu_detail_percentbar.dart';
import 'dart:convert';
import 'package:ssafytime/controllers/loading_controller.dart';

import '../model/menu_detail.dart';

void openMenuDetail(BuildContext context, int id) async {
  loadingController.to.isLoading = true; // 일단 로딩 표시 on
  var res = await http.get(Uri.parse('http://i8a602.p.ssafy.io:9090/menu/detail?id=${id}'));
  var data = json.decode(res.body);
  loadingController.to.isLoading = false; //
  if (res.statusCode != 200) {
    print('api 오류');
    return ;
  }


  MenuDetail myMenu = MenuDetail(
    region: data['data']["region"],
    course: data['data']["course"],
    mainMenu: data['data']["mainMenu"],
    sideMenu: List<String>.from(data['data']["sideMenu"].map((x) => x)),
    cho: data['data']["cho"],
    kcal: data['data']["kcal"],
    fat: data['data']["fat"],
    protein: data['data']["protein"],
    sodium: data['data']["sodium"],
    imageUrl: data['data']["imageUrl"],
  );


  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0)
          )
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width * ( 365 / 392.7),
          height: MediaQuery.of(context).size.height * ( 683 / 803),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          padding: EdgeInsets.fromLTRB(12.5, 17, 12.5, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * ( 365 / 392.7),
                height: MediaQuery.of(context).size.height * ( 288 / 803),
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                  color: Color(0x30000000),
                  border: Border.all(width: 2, color: Color(0x503396F4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: myMenu.imageUrl != '' ? Image.network(myMenu.imageUrl, fit: BoxFit.contain)
                : Image.asset('assets/image/no_menu.png', fit: BoxFit.contain),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),),
              Container(
                width: MediaQuery.of(context).size.width * ( 365 / 392.7),
                height: MediaQuery.of(context).size.height * ( 354 / 803),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomText(content: myMenu.mainMenu, fontSize: 16,), // 메인메뉴
                    SizedBox(height: MediaQuery.of(context).size.height * ( 10 / 803),),

                    // 사이드 메뉴 목록
                    Container(
                      height: MediaQuery.of(context).size.height * ( 50 / 803),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: [
                          for (int i=0; i < myMenu.sideMenu.length; i++) ... [
                            CustomText(content: myMenu.sideMenu[i],
                              fontSize: 12, color: 0x60000000,)
                          ],
                        ]
                      ),
                    ),

                    // 영양소 percent
                    Container(
                      width: MediaQuery.of(context).size.width * ( 345 / 392.7),
                        height: MediaQuery.of(context).size.height * ( 190 / 803),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MDetailPercentBar(
                            title: '탄수화물',
                            amount: myMenu.cho,
                            total: 248,
                            unit: 'g',
                          ),
                          MDetailPercentBar(
                            title: '단백질',
                            amount: myMenu.protein,
                            total: 83,
                            unit: 'g',
                          ),
                          MDetailPercentBar(
                            title: '지방',
                            amount: myMenu.fat,
                            total: 97,
                            unit: 'g',
                          ),
                          MDetailPercentBar(
                            title: '나트륨',
                            amount: myMenu.sodium,
                            total: 3000,
                            unit: 'mg',
                          ),
                          MDetailPercentBar(
                            title: '총 Kcal',
                            amount: myMenu.kcal,
                            total: 2200,
                            unit: 'Kcal',
                          )
                        ],
                      )
                    )



                  ],
                ),
              ),
            ],
          ),
        );
      }
  );
}