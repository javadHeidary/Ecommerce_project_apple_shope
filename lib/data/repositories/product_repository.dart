import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/product_datasource.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/util/api_exception.dart';

abstract class IProductRepository {
  Future<Either<String, List<ProductModel>>> getMostSellerProductList();
  Future<Either<String, List<ProductModel>>> getMostViewProductList();
}

class ProductRepository extends IProductRepository {
  final IProductDatasource _productDatasource;
  ProductRepository(this._productDatasource);
  @override
  Future<Either<String, List<ProductModel>>> getMostSellerProductList() async {
    try {
      List<ProductModel> mostSellerProductList =
          await _productDatasource.getMostSellerProductList();
      return right(mostSellerProductList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }

  @override
  Future<Either<String, List<ProductModel>>> getMostViewProductList() async {
    try {
      List<ProductModel> mostViewProductList =
          await _productDatasource.getMostViewProductList();
      return right(mostViewProductList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }
}
