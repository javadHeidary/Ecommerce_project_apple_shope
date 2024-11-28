part of 'product_comment_bloc.dart';

sealed class ProductCommentEvent {}

final class ProductInitCommentListRequest extends ProductCommentEvent {
  final String productId;

  ProductInitCommentListRequest(this.productId);
}

final class ProductCommentListRequest extends ProductCommentEvent {
  final String productId;

  ProductCommentListRequest(this.productId);
}

final class ProductCommentPostRequest extends ProductCommentEvent {
  final String productId;
  final String comment;

  ProductCommentPostRequest(this.productId, this.comment);
}
