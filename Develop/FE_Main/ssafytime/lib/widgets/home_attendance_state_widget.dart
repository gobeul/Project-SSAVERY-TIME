import 'package:flutter/material.dart';

// 홈 스크린 출결 상태 위젯
class HA extends StatefulWidget {
  final int? absent; // 결석 횟수
  final int? tardy; // 지각 횟수
  final int? attendance; // 출석 횟수
  final String? imgURL; // 교육생 이미지 URL

  HA({Key? key, this.absent, this.attendance, this.tardy, this.imgURL})
      : super(key: key);

  @override
  State<HA> createState() => _HAState();
}

class _HAState extends State<HA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * ( 58 / 803),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: widget.imgURL != null
                  ? NetworkImage(widget.imgURL ?? "")
                  : AssetImage("assets/image/no_profile_image.png")
                      as ImageProvider,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * ( 284 / 392.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * ( 91.33 / 392.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // option1 결석 횟수
                        child: Text(
                          widget.absent.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: Color(0xffFF5449),
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          '결석',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * ( 91.33 / 392.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // option2 지각 횟수
                        child: Text(
                          widget.tardy.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: Color(0xffFFDE49),
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          '지각',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * ( 91.33 / 392.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // option3 출석 횟수
                        child: Text(
                          widget.attendance.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: Color(0xff3094F2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          '출석',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
