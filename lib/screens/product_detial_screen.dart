import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pelaicons/pelaicons.dart';
import 'package:shop/bloc/basket/basket_bloc.dart';
import 'package:shop/bloc/product_comment/product_comment_bloc.dart';
import 'package:shop/bloc/product_detial/product_detial_bloc.dart';
import 'package:shop/data/model/comment_model.dart';
import 'package:shop/data/model/product_image_model.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/data/model/product_property_model.dart';
import 'package:shop/data/model/product_variant_model.dart';
import 'package:shop/data/model/variant_model.dart';
import 'package:shop/data/model/variant_type_model.dart';
import 'package:shop/di/di.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/res/app_image.dart';
import 'package:shop/util/Extensions/int_extension.dart';
import 'package:shop/util/Extensions/string_extension.dart';
import 'package:shop/util/feedback_handler.dart';
import 'package:shop/widgets/animation_loding_widget.dart';
import 'package:shop/widgets/appbar__widget.dart';
import 'package:shop/widgets/cheched_image_widget.dart';
import 'package:shop/widgets/exception_text_widget.dart';
import 'package:shop/widgets/favarite_widget.dart';

class ProductDetialScreen extends StatelessWidget {
  const ProductDetialScreen({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = locator.get<ProductDetialBloc>();
        bloc.add(
          ProductDetialInitRequest(product.id!, product.category!),
        );
        return bloc;
      },
      child: _ContentProductDetialScreen(
        product: product,
      ),
    );
  }
}

class _ContentProductDetialScreen extends StatelessWidget {
  const _ContentProductDetialScreen({required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.backgroundScreenColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocBuilder<ProductDetialBloc, ProductDetialState>(
            builder: (context, state) {
              if (state is ProductDetialLoading) {
                return AnimationLoding.circle();
              }
              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  if (state is ProductDetialResponse) ...{
                    state.productCategory.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: ExceptionTextWidget(
                            exception: exception,
                          ),
                        );
                      },
                      (category) {
                        return SliverToBoxAdapter(
                          child: AppbarWidget(title: category.title ?? 'محصول'),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: _HeaderProdcutWidget(
                        productName: product.name!,
                      ),
                    ),
                    state.productImageList.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: ExceptionTextWidget(exception: exception),
                        );
                      },
                      (imageList) {
                        return SliverToBoxAdapter(
                          child: _GalleryProduct(
                            imageList: imageList,
                            defaultImage: product.thumbnail!,
                          ),
                        );
                      },
                    ),
                    state.productVariantList.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: ExceptionTextWidget(
                            exception: exception,
                          ),
                        );
                      },
                      (variantList) {
                        return SliverToBoxAdapter(
                          child: _VariantContinerGenerator(
                            productVariantList: variantList,
                          ),
                        );
                      },
                    ),
                    state.productProperties.fold(
                      (exception) {
                        return SliverToBoxAdapter(
                          child: ExceptionTextWidget(exception: exception),
                        );
                      },
                      (properties) {
                        return SliverToBoxAdapter(
                          child: _DetialSectionWidget(
                            description: product.description!,
                            properties: properties,
                          ),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: _ProductCommentSectionWidget(
                        productId: product.id!,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _FinalButtomWidget(
                        productPrice: product.price,
                        productRealPrice: product.realPrice!,
                        productPercent: product.percent!,
                        product: product,
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 20),
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

class _VariantContinerGenerator extends StatelessWidget {
  const _VariantContinerGenerator({required this.productVariantList});
  final List<ProductVariantModel> productVariantList;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var productVariant in productVariantList) ...{
          if (productVariant.variantList!.isNotEmpty) ...{
            _VariantGenaratorChild(
              productVariant: productVariant,
            )
          }
        }
      ],
    );
  }
}

class _VariantGenaratorChild extends StatelessWidget {
  const _VariantGenaratorChild({required this.productVariant});
  final ProductVariantModel productVariant;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productVariant.variantType!.title!,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'SM',
              color: Colors.black,
            ),
          ),
          const Gap(10),
          if (productVariant.variantType!.type == VariantTypeEnum.COLOR) ...{
            _ColorVariantWidget(
              variantList: productVariant.variantList!,
            )
          },
          if (productVariant.variantType!.type == VariantTypeEnum.STORAGE) ...{
            _StorageVaraintWidget(
              variantList: productVariant.variantList!,
            )
          },
          if (productVariant.variantType!.type == VariantTypeEnum.VOLTAGE) ...{
            _VoltageVaraintWidget(
              variantList: productVariant.variantList!,
            )
          },
        ],
      ),
    );
  }
}

class _FinalButtomWidget extends StatelessWidget {
  const _FinalButtomWidget(
      {required this.productPrice,
      required this.productRealPrice,
      required this.productPercent,
      required this.product});
  final int productPrice;
  final int productRealPrice;
  final num productPercent;
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
        bottom: 10,
        top: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BasketBottomWidget(
            product: product,
          ),
          _PriceBottomWidget(
            productPrice: productPrice,
            productRealPrice: productRealPrice,
            productPercent: productPercent,
          ),
        ],
      ),
    );
  }
}

class _StorageVaraintWidget extends StatelessWidget {
  _StorageVaraintWidget({required this.variantList});
  final List<VariantModel> variantList;
  final ValueNotifier<int> storageSelected = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: ListView.builder(
        itemCount: variantList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              storageSelected.value = index;
            },
            child: ValueListenableBuilder(
              valueListenable: storageSelected,
              builder: (context, storageSelected, child) {
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: storageSelected == index ? 1.5 : 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: storageSelected == index
                          ? AppColor.blue
                          : AppColor.black,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      variantList[index].value!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: storageSelected == index
                            ? AppColor.blue
                            : AppColor.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _VoltageVaraintWidget extends StatelessWidget {
  _VoltageVaraintWidget({required this.variantList});
  final List<VariantModel> variantList;
  final ValueNotifier<int> voltageSelected = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: ListView.builder(
        itemCount: variantList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              voltageSelected.value = index;
            },
            child: ValueListenableBuilder(
              valueListenable: voltageSelected,
              builder: (context, storageSelected, child) {
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: storageSelected == index ? 1.5 : 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: storageSelected == index
                          ? AppColor.blue
                          : AppColor.black,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      variantList[index].value!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: storageSelected == index
                            ? AppColor.blue
                            : AppColor.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ColorVariantWidget extends StatelessWidget {
  _ColorVariantWidget({required this.variantList});
  final List<VariantModel> variantList;
  final ValueNotifier<int> colorSelcetedNotifire = ValueNotifier(0);
  final ValueNotifier<double> widthNotifire = ValueNotifier(24);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: ListView.builder(
        itemCount: variantList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              colorSelcetedNotifire.value = index;
              if (widthNotifire.value != 30) {
                widthNotifire.value += 6;
              }
            },
            child: ValueListenableBuilder(
              valueListenable: colorSelcetedNotifire,
              builder: (_, colorSelcetedNotifie, child) {
                return ValueListenableBuilder(
                  valueListenable: widthNotifire,
                  builder: (_, value, child) {
                    return AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      margin: const EdgeInsets.only(left: 10),
                      width: colorSelcetedNotifie == index ? value : 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: variantList[index].value.stringToColor(),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: AppColor.backgroundScreenColor,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DetialSectionWidget extends StatelessWidget {
  const _DetialSectionWidget({
    required this.properties,
    required this.description,
  });
  final List<ProductPropertyModel> properties;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (properties.isNotEmpty) ...{
          _PropertiesProductWidget(properties: properties),
        },
        if (description.isNotEmpty) ...{
          _DescriptionProductWidget(description: description),
        },
      ],
    );
  }
}

class _GalleryProduct extends StatelessWidget {
  _GalleryProduct({required this.imageList, required this.defaultImage});
  final List<ProductImageModel> imageList;
  final String defaultImage;
  final ValueNotifier<int> selectedImageNotifire = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
        top: 15,
      ),
      height: 284,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: -15,
            offset: Offset(0.0, 10),
            color: AppColor.gray,
          ),
        ],
      ),
      child: ValueListenableBuilder(
        valueListenable: selectedImageNotifire,
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FavoriteWidget(color: AppColor.gray),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: (imageList.isEmpty)
                                ? CachedImage(imageUrl: defaultImage)
                                : CachedImage(
                                    imageUrl:
                                        imageList[selectedImageNotifire.value]
                                            .urlImage,
                                  ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            '4.5',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'SM',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Icon(
                          Pelaicons.star_svg_bold,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                ),
                if (imageList.isNotEmpty) ...{
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 44,
                      left: 44,
                      top: 10,
                      bottom: 10,
                    ),
                    child: SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(left: 20),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColor.gray,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    selectedImageNotifire.value = index;
                                  },
                                  child: CachedImage(
                                    imageUrl: imageList[index].urlImage,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                }
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderProdcutWidget extends StatelessWidget {
  const _HeaderProdcutWidget({required this.productName});
  final String productName;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          productName,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'SB',
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _ProductCommentSectionWidget extends StatelessWidget {
  const _ProductCommentSectionWidget({required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          useSafeArea: true,
          enableDrag: true,
          showDragHandle: true,
          backgroundColor: AppColor.white,
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) {
                var bloc = locator.get<ProductCommentBloc>();
                bloc.add(
                  ProductCommentListRequest(
                    productId,
                  ),
                );
                return bloc;
              },
              child: _ContentModelButtomSheet(
                productId: productId,
              ),
            );
          },
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColor.black,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'نظرات دیگران :',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'SB',
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                const Text(
                  'مشاهده',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'SB',
                    color: AppColor.blue,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColor.blue,
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: AppColor.blue,
                      size: 17,
                      weight: 5,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ContentModelButtomSheet extends StatelessWidget {
  _ContentModelButtomSheet({required this.productId});
  final TextEditingController _commentController = TextEditingController();
  final String productId;
  final ValueNotifier<bool> isVisibleNotifire = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    NotificationListener<UserScrollNotification>(
                      onNotification: (notif) {
                        if (notif.direction == ScrollDirection.forward) {
                          return isVisibleNotifire.value = true;
                        }
                        if (notif.direction == ScrollDirection.reverse) {
                          return isVisibleNotifire.value = false;
                        } else {
                          return isVisibleNotifire.value = true;
                        }
                      },
                      child:
                          BlocBuilder<ProductCommentBloc, ProductCommentState>(
                        builder: (context, state) {
                          return CustomScrollView(
                            slivers: [
                              if (state is ProductCommentLoading) ...{
                                SliverToBoxAdapter(
                                  child: AnimationLoding.circle(),
                                )
                              } else if (state
                                  is ProductCommentListResponse) ...{
                                state.productCommentList.fold(
                                  (exception) {
                                    return SliverToBoxAdapter(
                                      child: ExceptionTextWidget(
                                        exception: exception,
                                      ),
                                    );
                                  },
                                  (comments) {
                                    return SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        childCount: comments.length,
                                        (context, index) {
                                          if (comments.isEmpty) {
                                            return const Center(
                                              child: Text(
                                                '! نظری برای این محصول ثبت نشده',
                                              ),
                                            );
                                          }
                                          return _ChildContentModelButtomSheetWidget(
                                            comments: comments,
                                            index: index,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              }
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: isVisibleNotifire,
              builder: (context, value, child) {
                return Visibility(
                  visible: isVisibleNotifire.value,
                  child: BlocListener<ProductCommentBloc, ProductCommentState>(
                    listener: (context, state) {
                      if (state is ProductCommentPostResponse) {
                        return state.postResponse.fold(
                          (exception) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              FeedbackHandler.customSnackBar(
                                  message: exception),
                            );
                          },
                          (response) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              FeedbackHandler.customSnackBar(
                                message: response,
                                color: AppColor.green,
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundScreenColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _commentController,
                        cursorColor: AppColor.blueIndicator,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'افزودن نظر ...',
                          hintStyle:
                              const TextStyle(fontSize: 14, fontFamily: 'dana'),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          prefixIcon: IconButton(
                            onPressed: () {
                              context.read<ProductCommentBloc>().add(
                                    ProductCommentPostRequest(
                                      productId,
                                      _commentController.text,
                                    ),
                                  );
                              _commentController.text = '';
                            },
                            icon: Transform.rotate(
                              angle: 3.1,
                              child: const Icon(
                                Icons.send,
                                color: AppColor.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildContentModelButtomSheetWidget extends StatelessWidget {
  const _ChildContentModelButtomSheetWidget(
      {required this.comments, required this.index});
  final List<CommentModel> comments;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: comments[index].avatar!.isEmpty
                ? Image.asset(
                    AppImage.avatarUser,
                  )
                : CachedImage(
                    imageUrl: comments[index].userThumbnailUrl,
                    raduis: 30,
                  ),
          ),
          const Gap(10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comments[index].userName!.isEmpty
                      ? 'کاربر'
                      : comments[index].userName!,
                ),
                const Gap(5),
                Text(comments[index].text!),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _PriceBottomWidget extends StatelessWidget {
  const _PriceBottomWidget({
    required this.productPrice,
    required this.productRealPrice,
    required this.productPercent,
  });
  final int productPrice;
  final int productRealPrice;
  final num productPercent;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 138,
          height: 62,
          decoration: BoxDecoration(
            color: AppColor.green,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              width: 157,
              height: 53,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Text(
                        'تومان',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'SM',
                          color: Colors.white,
                        ),
                      ),
                      const Gap(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            productPrice.numberSeprated(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'SM',
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.white,
                                decorationThickness: 2),
                          ),
                          Text(
                            productRealPrice.numberSeprated(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'SM',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColor.red),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          child: Text(
                            '%${productPercent.round()}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'SB',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BasketBottomWidget extends StatelessWidget {
  const _BasketBottomWidget({required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ProductDetialBloc>().add(
              ProductAddToBasketRequest(product),
            );
        context.read<BasketBloc>().add(
              BasketInitRequest(),
            );
        FeedbackHandler.customTost(
            message: 'محصول به سبد خرید اضافه شد', color: AppColor.green);
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 138,
            height: 62,
            decoration: BoxDecoration(
              color: AppColor.blue,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                width: 157,
                height: 53,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: const Center(
                  child: Text(
                    'افزودن به سبد خرید',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'SB',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertiesProductWidget extends StatelessWidget {
  _PropertiesProductWidget({required this.properties});
  final List<ProductPropertyModel> properties;
  final ValueNotifier<bool> isTappedNotifire = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            isTappedNotifire.value = !isTappedNotifire.value;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColor.black,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'مشخصات فنی :',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'SB',
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'مشاهده',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SB',
                        color: AppColor.blue,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColor.blue,
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: AppColor.blue,
                          size: 17,
                          weight: 5,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isTappedNotifire,
          builder: (_, isTappedNotifire, child) {
            return Visibility(
              visible: isTappedNotifire,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColor.black,
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Text(
                          properties[index].title!,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'SM',
                            height: 1.8,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          properties[index].value!,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'SM',
                            height: 1.8,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DescriptionProductWidget extends StatelessWidget {
  _DescriptionProductWidget({required this.description});
  final String description;
  final ValueNotifier<bool> isTappedNotifire = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            isTappedNotifire.value = !isTappedNotifire.value;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColor.black,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'توضیحات محصول :',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'SB',
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'مشاهده',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SB',
                        color: AppColor.blue,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColor.blue,
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: AppColor.blue,
                          size: 17,
                          weight: 5,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isTappedNotifire,
          builder: (_, isTappedNotifire, child) {
            return Visibility(
              visible: isTappedNotifire,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColor.black,
                    width: 1,
                  ),
                ),
                child: Text(
                  description,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'SM',
                    height: 1.8,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
