import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/screens/product_list_screen.dart';
import 'package:shop/util/Extensions/string_extension.dart';
import 'package:shop/widgets/cheched_image_widget.dart';

class CategorayHorizontalWidget extends StatelessWidget {
  const CategorayHorizontalWidget({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(
              category: category,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: ShapeDecoration(
                  color: category.color.stringToColor(),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  shadows: [
                    BoxShadow(
                      color: category.color.stringToColor(),
                      blurRadius: 25,
                      offset: const Offset(0.0, 10),
                      spreadRadius: -12,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 22,
                height: 22,
                child: Center(
                  child: CachedImage(imageUrl: category.icon),
                ),
              ),
            ],
          ),
          const Gap(5),
          Text(
            category.title!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'SB',
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
