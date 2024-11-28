import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/product_detial_datasource.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/data/model/product_image_model.dart';
import 'package:shop/data/model/product_property_model.dart';
import 'package:shop/data/model/product_variant_model.dart';
import 'package:shop/util/api_exception.dart';

abstract class IProductDetialRepository {
  Future<Either<String, List<ProductImageModel>>> getProductImageList(
    String productId,
  );
  Future<Either<String, List<ProductVariantModel>>> getProductVaraintList(
      String productId);
  Future<Either<String, CategoryModel>> getProductCategory(String categoryId);
  Future<Either<String, List<ProductPropertyModel>>> getProductProperties(
      String productId);
}

class ProductDetialRepository extends IProductDetialRepository {
  final IProductDetialDatasource _productDetialDataSource;
  ProductDetialRepository(this._productDetialDataSource);
  @override
  Future<Either<String, List<ProductImageModel>>> getProductImageList(
      String productId) async {
    try {
      List<ProductImageModel> productImageList =
          await _productDetialDataSource.getProductImageList(productId);
      return right(productImageList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }

  @override
  Future<Either<String, List<ProductVariantModel>>> getProductVaraintList(
      String productId) async {
    try {
      List<ProductVariantModel> productVarintList =
          await _productDetialDataSource.getProductVariantList(productId);
      return right(productVarintList);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }

  @override
  Future<Either<String, CategoryModel>> getProductCategory(
      String categoryId) async {
    try {
      CategoryModel productCategory =
          await _productDetialDataSource.getProductCategory(categoryId);
      return right(productCategory);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }

  @override
  Future<Either<String, List<ProductPropertyModel>>> getProductProperties(
      String productId) async {
    try {
      List<ProductPropertyModel> productProperties =
          await _productDetialDataSource.getProductProperties(productId);
      return right(productProperties);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }
}
