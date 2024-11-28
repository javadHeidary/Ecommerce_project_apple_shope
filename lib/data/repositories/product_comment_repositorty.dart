import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/product_comment_datasource.dart';
import 'package:shop/data/model/comment_model.dart';
import 'package:shop/util/api_exception.dart';

abstract class IProductCommentRepositorty {
  Future<Either<String, List<CommentModel>>> getProductCommentList(
      String productId);
  Future<Either<String, String>> postProductComment(
      String productId, String comment);
}

class ProductCommentRepositorty extends IProductCommentRepositorty {
  final IProductCommentDatasource _productCommentDatasource;
  ProductCommentRepositorty(this._productCommentDatasource);
  @override
  Future<Either<String, List<CommentModel>>> getProductCommentList(
      String productId) async {
    try {
      List<CommentModel> productCommentList =
          await _productCommentDatasource.getProductCommentList(productId);
      return right(productCommentList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }

  @override
  Future<Either<String, String>> postProductComment(
      String productId, String comment) async {
    try {
      await _productCommentDatasource.postProductComment(productId, comment);
      return right('نظر شما افزوده شد');
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متن برای خطا تعریف نشده');
    }
  }
}
