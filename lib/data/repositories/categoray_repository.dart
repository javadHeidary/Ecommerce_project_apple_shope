import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/categoray_datasource.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/util/api_exception.dart';

abstract class ICategorayRepository {
  Future<Either<String, List<CategoryModel>>> getCategorayList();
}

class CategorayRepository extends ICategorayRepository {
  final ICategorayDatasource _categorayDatasource;
  CategorayRepository(this._categorayDatasource);
  @override
  Future<Either<String, List<CategoryModel>>> getCategorayList() async {
    try {
      List<CategoryModel> categorayList =
          await _categorayDatasource.getCategorayList();
      return right(categorayList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }
}
