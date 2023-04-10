// check menubook screen
import 'package:flutter/material.dart';

import '../widgets/menu_day_of_week.dart';

class MenuBookScreen extends StatelessWidget {
  const MenuBookScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("식단표"),
      ),
      body: SizedBox(
          child: Column(
        children: [
          MDay0fWeek(),
        ],
      )),
    );
  }
}
