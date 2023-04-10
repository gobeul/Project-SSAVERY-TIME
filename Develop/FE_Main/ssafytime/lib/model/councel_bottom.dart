import 'dart:convert';

// 상담 신청 데이터 모델 ==========================================================
CouncelApplication councelApplicationFromJson(String str) => CouncelApplication.fromJson(json.decode(str));

String councelApplicationToJson(CouncelApplication data) => json.encode(data.toJson());

class CouncelApplication {
  CouncelApplication({
    this.studentId,
    this.managerId,
    this.rezDate,
    this.rezTime,
    this.title,
    this.category,
  });

  int? studentId;
  int? managerId;
  String? rezDate;
  String? rezTime;
  String? title;
  String? category;

  factory CouncelApplication.fromJson(Map<String, dynamic> json) => CouncelApplication(
    studentId: json["studentId"],
    managerId: json["managerId"],
    rezDate: json["rezDate"],
    rezTime: json["rezTime"],
    title: json["title"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "managerId": managerId,
    "rezDate": rezDate,
    "rezTime": rezTime,
    "title": title,
    "category": category,
  };
}


// 상담 시간 선택 버튼에서 쓸거임
class staticTimeTable {
  Map<double, String> _table = {
    9.0 : '9:00', 9.5 : '9:30',
    10.0 : '10:00', 10.5 : '10:30',
    11.0 : '11:00', 11.5 : '11:30',
    12.0 : '12:00', 12.5 : '12:30',
    13.0 : '13:00', 13.5 : '13:30',
    14.0 : '14:00', 14.5 : '14:30',
    15.0 : '15:00', 15.5 : '15:30',
    16.0 : '16:00', 16.5 : '16:30',
    17.0 : '17:00', 17.5 : '17:30',
  };
  Map get table => _table;
}



// 상담 카테고리 선택 버튼 데이터
class staticCategory {
  List<String> _table = [
    '취업', '코딩', '알고리즘', 'FE', 'BE', 'JAVA', 'PYTHON',
    'Spring', 'Django','eeeeeeeeeeeeeeeeeeee'
  ];
  List get table => _table;
}