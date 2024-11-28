part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeResponse extends HomeState {
  final Either<String, List<BannerModel>> bannerList;
  final Either<String, List<CategoryModel>> categoryList;
  final Either<String, List<ProductModel>> productMostViewList;
  final Either<String, List<ProductModel>> productMostSellerList;

  HomeResponse(
    this.bannerList,
    this.categoryList,
    this.productMostViewList,
    this.productMostSellerList,
  );
}
