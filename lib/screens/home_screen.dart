import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pelaicons/pelaicons.dart';
import 'package:shop/bloc/home/home_bloc.dart';
import 'package:shop/data/model/bannner_model.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/widgets/animation_loding_widget.dart';
import 'package:shop/widgets/banner_slider_widget.dart';
import 'package:shop/widgets/categoray_horizontal_widget.dart';
import 'package:shop/widgets/product_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = locator.get<HomeBloc>();
        bloc.add(HomeInitRequest());
        return bloc;
      },
      child: const _ContentHomeScreen(),
    );
  }
}

class _ContentHomeScreen extends StatelessWidget {
  const _ContentHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.backgroundScreenColor,
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(
                  child: AnimationLoding.circle(),
                );
              } else if (state is HomeResponse) {
                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: _SearchBox(),
                    ),
                    state.bannerList.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: Text(
                            exception,
                            style: const TextStyle(
                              color: AppColor.red,
                              fontSize: 15,
                              fontFamily: 'SM',
                            ),
                          ),
                        );
                      },
                      (bannerList) {
                        return SliverToBoxAdapter(
                          child: _BannerSlider(bannerList: bannerList),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(
                      child: _TitleCategotay(),
                    ),
                    state.categoryList.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: Text(
                            exception,
                            style: const TextStyle(
                              color: AppColor.red,
                              fontSize: 25,
                              fontFamily: 'SB',
                            ),
                          ),
                        );
                      },
                      (categoryList) {
                        return SliverToBoxAdapter(
                          child: _CategorayList(
                            categoryList: categoryList,
                          ),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(
                      child: _TitleMostSeller(),
                    ),
                    state.productMostSellerList.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: Text(
                            exception,
                            style: const TextStyle(
                              color: AppColor.red,
                              fontSize: 25,
                              fontFamily: 'SB',
                            ),
                          ),
                        );
                      },
                      (productList) {
                        return SliverToBoxAdapter(
                          child: _MostSellerList(
                            productList: productList,
                          ),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(
                      child: _TitleMostView(),
                    ),
                    state.productMostViewList.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: Text(
                            exception,
                            style: const TextStyle(
                              color: AppColor.red,
                              fontSize: 25,
                              fontFamily: 'SB',
                            ),
                          ),
                        );
                      },
                      (productList) {
                        return SliverToBoxAdapter(
                          child: _MostViewList(
                            productList: productList,
                          ),
                        );
                      },
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    'خطایی در دریافت اطلاعت پیش امده',
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 15,
                      fontFamily: 'SM',
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _TitleMostView extends StatelessWidget {
  const _TitleMostView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 20,
        top: 25,
        bottom: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'بیشترین بازدید ها',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'SB',
              color: AppColor.gray,
            ),
          ),
          Row(
            children: [
              const Text(
                'مشاهده همه',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'SB',
                  color: AppColor.blue,
                ),
              ),
              const Gap(5),
              Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColor.blue),
                ),
                child: const Center(
                  child: Icon(
                    color: AppColor.blue,
                    Icons.chevron_right,
                    size: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _MostViewList extends StatelessWidget {
  const _MostViewList({required this.productList});
  final List<ProductModel> productList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(right: 17, left: 8.5)
                : const EdgeInsets.only(right: 8.5, left: 8.5),
            child: ProductWidget(
              product: productList[index],
            ),
          );
        },
      ),
    );
  }
}

class _MostSellerList extends StatelessWidget {
  const _MostSellerList({required this.productList});
  final List<ProductModel> productList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(right: 17, left: 8.5)
                : const EdgeInsets.only(right: 8.5, left: 8.5),
            child: ProductWidget(
              product: productList[index],
            ),
          );
        },
      ),
    );
  }
}

class _TitleMostSeller extends StatelessWidget {
  const _TitleMostSeller();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 20,
        top: 15,
        bottom: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'پرفروش ترین ها',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'SB',
              color: AppColor.gray,
            ),
          ),
          Row(
            children: [
              const Text(
                'مشاهده همه',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'SB',
                  color: AppColor.blue,
                ),
              ),
              const Gap(5),
              Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColor.blue),
                ),
                child: const Center(
                  child: Icon(
                    color: AppColor.blue,
                    Icons.chevron_right,
                    size: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _TitleCategotay extends StatelessWidget {
  const _TitleCategotay();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 10, right: 20, top: 32, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'دسته بندی',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'SB',
              color: AppColor.gray,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorayList extends StatelessWidget {
  const _CategorayList({required this.categoryList});
  final List<CategoryModel> categoryList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 17, left: 10),
            child: CategorayHorizontalWidget(
              category: categoryList[index],
            ),
          );
        },
      ),
    );
  }
}

class _BannerSlider extends StatelessWidget {
  const _BannerSlider({required this.bannerList});
  final List<BannerModel> bannerList;
  @override
  Widget build(BuildContext context) {
    return BannerSliderWidget(
      bannerList: bannerList,
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
        top: 20,
        bottom: 30,
      ),
      height: 46,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(
              Pelaicons.search_light_outline,
              size: 25,
            ),
            Gap(10),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                'جستجوی محصولات',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'SB',
                  color: AppColor.gray,
                ),
              ),
            ),
            Spacer(),
            Icon(
              Icons.apple,
              color: AppColor.blue,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
