import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/category_product_datasource.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/util/api_exception.dart';

abstract class ICategoryByProductRepository {
  Future<Either<String, List<ProductModel>>> getCategorayByProductList(
      String categoryId);
}

class CategoryByProductRepository extends ICategoryByProductRepository {
  final ICategoryByProductDatasource _categoryByProductDatasource;
  CategoryByProductRepository(this._categoryByProductDatasource);

  @override
  Future<Either<String, List<ProductModel>>> getCategorayByProductList(
      String categoryId) async {
    try {
      List<ProductModel> categoryByProductList =
          await _categoryByProductDatasource
              .getCategorayByProductList(categoryId);
      return right(categoryByProductList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }
}
