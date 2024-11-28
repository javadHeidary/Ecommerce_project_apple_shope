import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:shop/bloc/product_list/product_list_bloc.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/di/di.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/res/app_svg.dart';
import 'package:shop/screens/product_detial_screen.dart';
import 'package:shop/widgets/animation_loding_widget.dart';
import 'package:shop/widgets/appbar__widget.dart';
import 'package:shop/widgets/product_widget.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = locator.get<ProductListBloc>();
        bloc.add(
          ProductListRequest(category.id!),
        );
        return bloc;
      },
      child: _ContentPrductListScreen(
        category: category,
      ),
    );
  }
}

class _ContentPrductListScreen extends StatelessWidget {
  const _ContentPrductListScreen({required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.backgroundScreenColor,
        body: SafeArea(
          child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListLoading) {
                return Center(
                  child: AnimationLoding.circle(),
                );
              } else if (state is ProductListResponse) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: AppbarWidget(title: category.title ?? 'محصولات'),
                    ),
                    state.categoryByProductList.fold(
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
                        if (productList.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: _EmptyFolderWidget(),
                          );
                        } else {
                          return SliverPadding(
                            padding: const EdgeInsets.only(
                              right: 20,
                              left: 20,
                              bottom: 20,
                            ),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 600
                                        ? 4
                                        : 2,
                                childAspectRatio:
                                    MediaQuery.of(context).size.width > 600
                                        ? 2 / 3
                                        : 1 / 1.3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                childCount: productList.length,
                                (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetialScreen(
                                            product: productList[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProductWidget(
                                      product: productList[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    'خطایی در دریافت اطلاعت پیش امده',
                    style: TextStyle(
                      color: AppColor.red,
                      fontSize: 25,
                      fontFamily: 'SB',
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

class _EmptyFolderWidget extends StatelessWidget {
  const _EmptyFolderWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(200),
        SvgPicture.asset(
          AppSvg.emptyFolder,
          color: AppColor.blue,
          width: 150,
          height: 150,
        ),
        const Gap(5),
        const Text(
          'محصولی وجود ندارد !',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 15,
            fontFamily: 'SM',
          ),
        ),
      ],
    );
  }
}
