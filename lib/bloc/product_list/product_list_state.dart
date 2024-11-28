part of 'product_list_bloc.dart';

sealed class ProductListState {}

final class ProductInitList extends ProductListState {}

final class ProductListLoading extends ProductListState {}

final class ProductListResponse extends ProductListState {
  final Either<String, List<ProductModel>> categoryByProductList;

  ProductListResponse(this.categoryByProductList);
}
