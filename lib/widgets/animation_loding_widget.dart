import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop/res/app_color.dart';

class AnimationLoding {
  static Widget circle({Color color = AppColor.blueIndicator}) {
    return Center(
      child: SpinKitCircle(color: color),
    );
  }

  static Widget threeBounce({Color color = AppColor.white, double size = 20}) {
    return Center(
      child: SpinKitThreeBounce(
        color: color,
        size: size,
      ),
    );
  }
}
