import 'package:dio/dio.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/util/api_exception.dart';
import 'package:shop/util/map_handler.dart';

abstract class ICategoryByProductDatasource {
  Future<List<ProductModel>> getCategorayByProductList(categoryId);
}

class CategoryByProductRemote extends ICategoryByProductDatasource {
  final Dio _dio;
  CategoryByProductRemote(this._dio);
  @override
  Future<List<ProductModel>> getCategorayByProductList(categoryId) async {
    if (categoryId == 'qnbj8d6b9lzzpn8') {
      try {
        Response response = await _dio.get(
          'collections/products/records',
        );
        List<ProductModel> categoryWithProductList =
            MapHandler.mapForJsonToModelList(
                response.data['items'], ProductModel.fromJson);
        return categoryWithProductList;
      } on DioException catch (ex) {
        throw ApiException(
            ex.response?.data['message'], ex.response?.statusCode);
      } catch (ex) {
        throw ApiException('unknown exception', 0);
      }
    } else {
      final Map<String, String> qPatamt = {
        'filter': 'category = "$categoryId"'
      };
      try {
        Response response = await _dio.get('collections/products/records',
            queryParameters: qPatamt);
        List<ProductModel> categoryWithProductList =
            MapHandler.mapForJsonToModelList(
                response.data['items'], ProductModel.fromJson);
        return categoryWithProductList;
      } on DioException catch (ex) {
        throw ApiException(
            ex.response?.data['message'], ex.response?.statusCode);
      } catch (ex) {
        throw ApiException('unknown exception', 0);
      }
    }
  }
}
