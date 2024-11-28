part of 'product_detial_bloc.dart';

sealed class ProductDetialEvent {}

final class ProductDetialInitRequest extends ProductDetialEvent {
  final String productId;
  final String categoryId;
  ProductDetialInitRequest(this.productId, this.categoryId);
}

final class ProductAddToBasketRequest extends ProductDetialEvent {
  final ProductModel product;
  ProductAddToBasketRequest(this.product);
}
