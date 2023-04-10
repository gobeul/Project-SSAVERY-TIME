import 'package:flutter/material.dart';

class STimeTable extends StatelessWidget {
  const STimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      child: Scrollbar(
        child: SingleChildScrollView(
              child : Column(
              children: [
                Container(
                  color: Colors.amber,
                  width: MediaQuery.of(context).size.width * ( 32 / 392.7),
                  height: 1010,
                ),
                Container(
                  color: Colors.black12,
                  width: MediaQuery.of(context).size.width * ( 32 / 392.7),
                  height: 1010,
                ),
              ],
            )
        ),
      ),
    );
  }
}
