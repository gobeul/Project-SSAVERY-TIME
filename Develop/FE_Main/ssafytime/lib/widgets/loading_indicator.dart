import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ssafytime/controllers/loading_controller.dart';
import 'package:get/get.dart';

class LoadingIndicator extends StatelessWidget {

  LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage: !loadingController.to.isLoading,
        child: Center(
          child: Container(
            color: Color(0x40000000),
            width: double.infinity, height: double.infinity,
            child: SpinKitFadingCircle(
              color: Colors.white,
              size: 80,
            ),
          ),
        )
    );
  }
}
