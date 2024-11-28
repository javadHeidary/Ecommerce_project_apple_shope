import 'package:dio/dio.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/util/api_exception.dart';
import 'package:shop/util/map_handler.dart';

abstract class IProductDatasource {
  Future<List<ProductModel>> getMostSellerProductList();
  Future<List<ProductModel>> getMostViewProductList();
}

class ProductRemote extends IProductDatasource {
  final Dio _dio;
  ProductRemote(this._dio);
  @override
  Future<List<ProductModel>> getMostSellerProductList() async {
    final Map<String, String> qParamt = {
      'filter': 'popularity = "Best Seller"'
    };
    try {
      Response response = await _dio.get(
        'collections/products/records',
        queryParameters: qParamt,
      );
      List<ProductModel> mostSellerProductList =
          MapHandler.mapForJsonToModelList<ProductModel>(
              response.data['items'], ProductModel.fromJson);
      return mostSellerProductList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }

  @override
  Future<List<ProductModel>> getMostViewProductList() async {
    final Map<String, String> qParamt = {'filter': 'popularity = "Hotest"'};
    try {
      Response response = await _dio.get(
        'collections/products/records',
        queryParameters: qParamt,
      );
      List<ProductModel> mostViewProductList =
          MapHandler.mapForJsonToModelList<ProductModel>(
              response.data['items'], ProductModel.fromJson);
      return mostViewProductList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }
}
