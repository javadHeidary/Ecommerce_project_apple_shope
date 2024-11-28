import 'package:dio/dio.dart';
import 'package:shop/data/model/bannner_model.dart';
import 'package:shop/util/api_exception.dart';
import 'package:shop/util/map_handler.dart';

abstract class IBannerDatasource {
  Future<List<BannerModel>> getBannerList();
}

class BannerRemote extends IBannerDatasource {
  final Dio _dio;
  BannerRemote(this._dio);
  @override
  Future<List<BannerModel>> getBannerList() async {
    try {
      Response response = await _dio.get('collections/banner/records');
      List<BannerModel> bannerList =
          MapHandler.mapForJsonToModelList<BannerModel>(
              response.data['items'], BannerModel.fromJson);
      return bannerList;
    } on DioException catch (ex) {
      throw ApiException(ex.response!.data['message'], ex.response!.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }
}
