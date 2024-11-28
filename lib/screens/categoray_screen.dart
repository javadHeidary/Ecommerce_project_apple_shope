import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/category/category_bloc.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/di/di.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/screens/product_list_screen.dart';
import 'package:shop/widgets/animation_loding_widget.dart';
import 'package:shop/widgets/appbar__widget.dart';
import 'package:shop/widgets/cheched_image_widget.dart';
import 'package:shop/widgets/exception_text_widget.dart';

class CategorayScreen extends StatelessWidget {
  const CategorayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = locator.get<CategoryBloc>();
        bloc.add(CategoryInitRequest());
        return bloc;
      },
      child: const _ContentCategorayScreen(),
    );
  }
}

class _ContentCategorayScreen extends StatelessWidget {
  const _ContentCategorayScreen();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.backgroundScreenColor,
        body: SafeArea(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return Center(
                  child: AnimationLoding.circle(),
                );
              } else if (state is CategoryListResponse) {
                return state.categoryList.fold(
                  (eception) {
                    return Center(
                      child: ExceptionTextWidget(
                        exception: eception,
                      ),
                    );
                  },
                  (categoryList) {
                    return _CategoryListWidget(
                      categoryList: categoryList,
                    );
                  },
                );
              }

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
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryListWidget extends StatelessWidget {
  const _CategoryListWidget({required this.categoryList});
  final List<CategoryModel> categoryList;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: AppbarWidget(
            title: 'دسته بندی',
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              childAspectRatio:
                  MediaQuery.of(context).size.width > 600 ? 2 / 3 : 2 / 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 15,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: categoryList.length,
              (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListScreen(
                          category: categoryList[index],
                        ),
                      ),
                    );
                  },
                  child: CachedImage(
                    imageUrl: categoryList[index].thumbnail,
                    raduis: 15,
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
