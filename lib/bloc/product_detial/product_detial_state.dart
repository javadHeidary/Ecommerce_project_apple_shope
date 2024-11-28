part of 'product_detial_bloc.dart';

sealed class ProductDetialState {}

final class ProductInitDetial extends ProductDetialState {}

final class ProductDetialLoading extends ProductDetialState {}

final class ProductDetialResponse extends ProductDetialState {
  final Either<String, CategoryModel> productCategory;
  final Either<String, List<ProductImageModel>> productImageList;
  final Either<String, List<ProductVariantModel>> productVariantList;
  final Either<String, List<ProductPropertyModel>> productProperties;

  ProductDetialResponse(
    this.productCategory,
    this.productImageList,
    this.productVariantList,
    this.productProperties,
  );
}

final class ProductAddedBasketResponse extends ProductDetialState {
  final Either<String, String> response;
  ProductAddedBasketResponse(this.response);
}
