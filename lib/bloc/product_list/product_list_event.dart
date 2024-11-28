part of 'product_list_bloc.dart';

sealed class ProductListEvent {}

final class ProductListRequest extends ProductListEvent {
  final String categoryId;
  ProductListRequest(this.categoryId);
}
