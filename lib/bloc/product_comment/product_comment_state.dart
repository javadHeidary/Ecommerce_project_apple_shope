part of 'product_comment_bloc.dart';

sealed class ProductCommentState {}

final class ProductCommentLoading extends ProductCommentState {}

final class ProductInitCommentList extends ProductCommentState {
  final Either<String, List<CommentModel>> productCommentList;

  ProductInitCommentList(this.productCommentList);
}

final class ProductCommentPostResponse extends ProductCommentState {
  final Either<String, String> postResponse;

  ProductCommentPostResponse(this.postResponse);
}

final class ProductCommentPostLoading extends ProductCommentState {}

final class ProductCommentListResponse extends ProductCommentState {
  final Either<String, List<CommentModel>> productCommentList;

  ProductCommentListResponse(this.productCommentList);
}
