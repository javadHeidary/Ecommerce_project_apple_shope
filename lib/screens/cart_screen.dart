import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:shop/bloc/basket/basket_bloc.dart';
import 'package:shop/data/model/hive_model/basket_item_model.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/res/app_svg.dart';
import 'package:shop/util/Extensions/int_extension.dart';
import 'package:shop/util/Extensions/string_extension.dart';
import 'package:shop/util/feedback_handler.dart';
import 'package:shop/widgets/appbar__widget.dart';
import 'package:shop/widgets/cheched_image_widget.dart';
import 'package:shop/widgets/exception_text_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    BlocProvider.of<BasketBloc>(context).add(BasketInitRequest());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.backgroundScreenColor,
        body: SafeArea(
          child: BlocConsumer<BasketBloc, BasketState>(
            listener: (context, state) {
              if (state is BasketRemoveProductResponsee) {
                return state.response.fold(
                  (exception) {
                    FeedbackHandler.customTost(
                        message: exception, color: AppColor.red);
                  },
                  (response) {
                    FeedbackHandler.customTost(
                        message: response, color: AppColor.red);
                  },
                );
              }
            },
            builder: (context, state) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      const SliverToBoxAdapter(
                        child: AppbarWidget(title: 'سبد خرید'),
                      ),
                      if (state is BasketResponse) ...{
                        state.basketItemList.fold(
                          (exception) {
                            return SliverToBoxAdapter(
                              child: ExceptionTextWidget(exception: exception),
                            );
                          },
                          (basketList) {
                            return SliverList.builder(
                              itemCount: basketList.length,
                              itemBuilder: (context, index) {
                                return _CartProductWidget(
                                  basketItem: basketList[index],
                                  index: index,
                                );
                              },
                            );
                          },
                        ),
                      },
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 60),
                      ),
                    ],
                  ),
                  if (state is BasketResponse) ...{
                    state.basketFinalPrice.fold(
                      (exception) {
                        return ExceptionTextWidget(exception: exception);
                      },
                      (finalPrice) {
                        return _FinalBuyButtom(
                          finalPrice: finalPrice,
                        );
                      },
                    ),
                  }
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CartProductWidget extends StatelessWidget {
  const _CartProductWidget({required this.basketItem, required this.index});
  final BasketItemModel basketItem;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Center(
                      child: CachedImage(imageUrl: basketItem.thumbnail),
                    ),
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        basketItem.name!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'SB',
                          color: Colors.black,
                        ),
                      ),
                      const Gap(5),
                      const Text(
                        'گارانتی 18 ماه مدیه پردازش',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'SM',
                          color: AppColor.gray,
                        ),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Text(
                            textDirection: TextDirection.rtl,
                            basketItem.price.numberSeprated(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'SM',
                              color: AppColor.gray,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColor.red,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              child: Text(
                                '%${basketItem.percent!.round()}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'SB',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: 200,
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 5,
                            children: [
                              _ProductOption(
                                color: '456712'.stringToColor(),
                                title: 'قرمز',
                              ),
                              _RemoveOption(
                                index: index,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: DottedDashedLine(
                height: 1,
                width: double.infinity,
                axis: Axis.horizontal,
                dashSpace: 2,
                dashColor: Colors.black.withOpacity(0.5),
                strokeWidth: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    basketItem.realPrice.numberSeprated(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'SM',
                      color: Colors.black,
                    ),
                  ),
                  const Gap(5),
                  const Text(
                    'تومان',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'SM',
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveOption extends StatelessWidget {
  const _RemoveOption({required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<BasketBloc>().add(
              BasketRemoveProductRequest(index),
            );
      },
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.gray.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Text(
              'حذف',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'SM',
                color: AppColor.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 3),
              child: SvgPicture.asset(
                AppSvg.trash,
                width: 15,
                height: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductOption extends StatelessWidget {
  const _ProductOption({required this.color, required this.title});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 50),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.gray.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'SM',
              color: AppColor.gray,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Container(
              width: 10,
              height: 10,
              decoration: ShapeDecoration(
                color: color,
                shape: const CircleBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FinalBuyButtom extends StatelessWidget {
  const _FinalBuyButtom({required this.finalPrice});
  final int finalPrice;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      left: 10,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 53,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.green,
          ),
          onPressed: () {},
          child: finalPrice == 0
              ? const Text(
                  'سبد خرید خالی است !',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'SM',
                    color: AppColor.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'مبلغ پرداختی : ',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SM',
                        color: AppColor.white,
                      ),
                    ),
                    Text(
                      finalPrice.numberSeprated(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'SM',
                        color: AppColor.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        'تومان',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'SM',
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
