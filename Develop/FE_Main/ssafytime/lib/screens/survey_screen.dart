// do survey screen

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ssafytime/controllers/survey_controller.dart';
import 'package:ssafytime/flutter_survey-0.1.4/flutter_survey.dart';

class SurveyScreen extends StatefulWidget {
  SurveyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SurveyScreen();
}

class _SurveyScreen extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  List<QuestionResult> _questionResult = [];

  late SurveyController surveyC;
  @override
  void initState() {
    surveyC = Get.put(SurveyController(
      surveyIdx: Get.arguments["surveyIdx"],
      surveyTitle: Get.arguments["surveyTitle"],
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("${surveyC}");
    return Obx(
      () => Scaffold(
        appBar:
            AppBar(scrolledUnderElevation: 0, title: Text(surveyC.surveyTitle)),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: SafeArea(
            child: surveyC.questions.length > 0
                ? Form(
                    key: _formKey,
                    child: Survey(
                      defaultErrorText: "문항을 선택해주세요",
                      initialData: [
                        for (int i = 0; i < surveyC.questions.length; i++) ...[
                          surveyC.questions[i].optionList.length > 1
                              ? Question(
                                  isMandatory: true,
                                  question:
                                      surveyC.questions[i].questionContent,
                                  answerChoices: Map.fromIterable(
                                      surveyC.questions[i].optionList,
                                      key: (e) => e.optionContent,
                                      value: (e) => null),
                                )
                              : Question(
                                  isMandatory: true,
                                  question:
                                      surveyC.questions[i].questionContent),
                        ]
                      ],
                      onNext: (questionResults) {
                        _questionResult = questionResults;
                      },
                    ),
                  )
                : Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "로딩 중 ....",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(170, 62, 61, 61)),
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 6),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.black),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    "그만하기",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xff0079D1),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    "제출하기",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      log(_questionResult.toString());
                      var result =
                          await surveyC.sendSurveyResult(_questionResult);

                      flutterToast(result);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void flutterToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        fontSize: 20,
        textColor: Colors.black26,
        toastLength: Toast.LENGTH_SHORT);
  }
}
