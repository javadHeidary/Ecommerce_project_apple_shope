import 'package:dio/dio.dart';
import 'package:shop/data/model/comment_model.dart';
import 'package:shop/util/auth_managment.dart';
import 'package:shop/util/api_exception.dart';
import 'package:shop/util/map_handler.dart';

abstract class IProductCommentDatasource {
  Future<List<CommentModel>> getProductCommentList(
    String productId,
  );
  Future<void> postProductComment(String productId, String comment);
}

class ProductCommentRemote extends IProductCommentDatasource {
  final Dio _dio;
  ProductCommentRemote(this._dio);
  final String userId = AuthManagment.getUserId();
  @override
  Future<List<CommentModel>> getProductCommentList(String productId) async {
    final Map<String, dynamic> qParamt = {
      'filter': 'product_id = "$productId"',
      'expand': 'user_id',
      'perPage': 600,
    };
    try {
      Response response = await _dio.get('collections/comment/records',
          queryParameters: qParamt);
      List<CommentModel> productCommentList = MapHandler.mapForJsonToModelList(
          response.data['items'], CommentModel.fromJson);
      return productCommentList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['items'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }

  @override
  Future<void> postProductComment(String productId, String comment) async {
    try {
      await _dio.post(
        'collections/comment/records',
        data: {
          'text': comment,
          'product_id': productId,
          'user_id': '9nshtfblt3n8vhv',
        },
      );
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknownErroe', 0);
    }
  }
}
