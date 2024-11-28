import 'package:flutter/material.dart';
import 'package:shop/data/model/bannner_model.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/widgets/cheched_image_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSliderWidget extends StatelessWidget {
  BannerSliderWidget({super.key, required this.bannerList});

  final PageController _bannerController = PageController(viewportFraction: .9);
  final List<BannerModel> bannerList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 177,
          child: PageView.builder(
            controller: _bannerController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 10),
                child: CachedImage(
                  imageUrl: bannerList[index].thumbnail,
                  raduis: 15,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 8,
          child: SmoothPageIndicator(
            controller: _bannerController,
            count: 4,
            effect: const ExpandingDotsEffect(
              dotColor: AppColor.white,
              dotHeight: 7,
              dotWidth: 7,
              expansionFactor: 4,
              activeDotColor: AppColor.blueIndicator,
            ),
          ),
        )
      ],
    );
  }
}
