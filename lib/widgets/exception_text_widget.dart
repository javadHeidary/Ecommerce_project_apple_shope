import 'package:flutter/material.dart';
import 'package:shop/res/app_color.dart';

class ExceptionTextWidget extends StatelessWidget {
  const ExceptionTextWidget({super.key, required this.exception});
  final String exception;
  @override
  Widget build(BuildContext context) {
    return Text(
      exception,
      style: const TextStyle(
        color: AppColor.red,
        fontSize: 15,
        fontFamily: 'SM',
      ),
    );
  }
}
