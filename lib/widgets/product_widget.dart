import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shop/bloc/basket/basket_bloc.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/di/di.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/screens/product_detial_screen.dart';
import 'package:shop/util/Extensions/int_extension.dart';
import 'package:shop/widgets/cheched_image_widget.dart';
import 'package:shop/widgets/favarite_widget.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (contex) => BlocProvider<BasketBloc>.value(
              value: locator.get<BasketBloc>(),
              child: ProductDetialScreen(
                product: product,
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(10),
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: CachedImage(imageUrl: product.thumbnail),
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 8,
                  child: FavoriteWidget(
                    color: AppColor.blue,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColor.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(
                        '%${product.percent!.round()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'SB',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Text(
                    product.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'SM',
                    ),
                  ),
                ),
                Container(
                  height: 53,
                  decoration: const BoxDecoration(
                    color: AppColor.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'تومان',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'SM',
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.price.numberSeprated(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'SM',
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.white,
                                decorationThickness: 2),
                          ),
                          Text(
                            product.realPrice.numberSeprated(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'SM',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          textDirection: TextDirection.ltr,
                          Icons.arrow_right_alt_outlined,
                          color: AppColor.blue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
