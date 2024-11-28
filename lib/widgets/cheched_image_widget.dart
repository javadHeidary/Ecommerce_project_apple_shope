import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/res/app_color.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, required this.imageUrl, this.raduis = 0});
  final String? imageUrl;
  final double raduis;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(raduis),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageUrl ?? 'خطا در بارگذاری تصویر',
        placeholder: (context, url) {
          return Container(
            color: AppColor.gray,
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            color: AppColor.red.withOpacity(0.3),
          );
        },
      ),
    );
  }
}
