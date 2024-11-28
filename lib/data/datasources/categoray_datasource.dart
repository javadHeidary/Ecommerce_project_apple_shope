import 'package:dio/dio.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/util/api_exception.dart';
import 'package:shop/util/map_handler.dart';

abstract class ICategorayDatasource {
  Future<List<CategoryModel>> getCategorayList();
}

class CategorayRemote extends ICategorayDatasource {
  final Dio _dio;
  CategorayRemote(this._dio);
  @override
  Future<List<CategoryModel>> getCategorayList() async {
    try {
      Response response = await _dio.get('collections/category/records');
      List<CategoryModel> categorayList =
          MapHandler.mapForJsonToModelList<CategoryModel>(
              response.data['items'], CategoryModel.fromJson);

      return categorayList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }
}
