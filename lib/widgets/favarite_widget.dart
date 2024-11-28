import 'package:flutter/material.dart';
import 'package:shop/res/app_color.dart';

class FavoriteWidget extends StatelessWidget {
  const FavoriteWidget({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Icon(
          color: AppColor.white,
          Icons.favorite,
          size: 17,
        ),
      ),
    );
  }
}
