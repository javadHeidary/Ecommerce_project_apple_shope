import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/res/app_color.dart';

class FeedbackHandler {
  static SnackBar customSnackBar(
      {required String message, Color color = AppColor.black}) {
    return SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            fontFamily: 'SM', fontSize: 14, color: AppColor.white),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );
  }

  static void customTost(
      {required String message, Color color = AppColor.black}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: AppColor.white,
      fontSize: 15.0,
      backgroundColor: color,
    );
  }
}
