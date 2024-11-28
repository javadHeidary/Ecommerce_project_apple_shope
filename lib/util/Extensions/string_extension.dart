import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ColorParser on String? {
  Color stringToColor() {
    String colorValue = 'FF' + this!;
    int hexColor = int.parse(colorValue, radix: 16);

    return Color(hexColor);
  }
}

extension ValidInput on String? {
  bool isValid() {
    return this != null && this!.isNotEmpty;
  }
}
