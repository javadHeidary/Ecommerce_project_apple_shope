import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/banner_datasource.dart';
import 'package:shop/data/model/bannner_model.dart';
import 'package:shop/util/api_exception.dart';

abstract class IBannerRepository {
  Future<Either<String, List<BannerModel>>> getBannerList();
}

class BannerRepository extends IBannerRepository {
  final IBannerDatasource _bannerDatasource;
  BannerRepository(this._bannerDatasource);
  @override
  Future<Either<String, List<BannerModel>>> getBannerList() async {
    try {
      List<BannerModel> bannerList = await _bannerDatasource.getBannerList();
      return right(bannerList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }
}
