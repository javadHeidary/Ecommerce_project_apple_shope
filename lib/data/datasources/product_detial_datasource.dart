import 'package:dio/dio.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/data/model/product_image_model.dart';
import 'package:shop/data/model/product_property_model.dart';
import 'package:shop/data/model/product_variant_model.dart';
import 'package:shop/data/model/variant_model.dart';
import 'package:shop/data/model/variant_type_model.dart';
import 'package:shop/util/api_exception.dart';
import 'package:shop/util/map_handler.dart';

abstract class IProductDetialDatasource {
  Future<List<ProductImageModel>> getProductImageList(String productId);
  Future<List<VariantModel>> getVariantList(String productId);
  Future<List<VariantTypeModel>> getVariantTypeList();
  Future<List<ProductVariantModel>> getProductVariantList(String productId);
  Future<CategoryModel> getProductCategory(String categorayId);
  Future<List<ProductPropertyModel>> getProductProperties(String productId);
}

class ProductDetialRemote extends IProductDetialDatasource {
  final Dio _dio;
  ProductDetialRemote(this._dio);
  @override
  Future<List<ProductImageModel>> getProductImageList(String productId) async {
    final Map<String, String> qParammt = {
      'filter': 'product_id = "$productId"'
    };
    try {
      Response response = await _dio.get(
        'collections/gallery/records',
        queryParameters: qParammt,
      );
      List<ProductImageModel> productImageList =
          MapHandler.mapForJsonToModelList<ProductImageModel>(
              response.data['items'], ProductImageModel.fromJson);
      return productImageList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('uknown exception', 0);
    }
  }

  @override
  Future<List<VariantModel>> getVariantList(String productId) async {
    final Map<String, String> qParamt = {'filter': 'product_id = "$productId"'};
    try {
      Response response = await _dio.get(
        'collections/variants/records',
        queryParameters: qParamt,
      );
      List<VariantModel> productVariantList =
          MapHandler.mapForJsonToModelList<VariantModel>(
              response.data['items'], VariantModel.fromJson);
      return productVariantList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }

  @override
  Future<List<VariantTypeModel>> getVariantTypeList() async {
    try {
      Response response = await _dio.get('collections/variants_type/records');
      List<VariantTypeModel> productVariantTypeList =
          MapHandler.mapForJsonToModelList<VariantTypeModel>(
              response.data['items'], VariantTypeModel.fromJson);
      return productVariantTypeList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }

  @override
  Future<List<ProductVariantModel>> getProductVariantList(
      String productId) async {
    List<ProductVariantModel> productVaraintModelList = [];
    List<VariantTypeModel> varinatTypeList = await getVariantTypeList();
    List<VariantModel> varinatList = await getVariantList(productId);

    for (var variantType in varinatTypeList) {
      var finalVaraintList = varinatList
          .where((element) => element.typeId == variantType.id)
          .toList();
      productVaraintModelList.add(
        ProductVariantModel(variantType, finalVaraintList),
      );
    }
    return productVaraintModelList;
  }

  @override
  Future<CategoryModel> getProductCategory(String categorayId) async {
    final Map<String, String> qParamt = {'filter': 'id = "$categorayId"'};
    try {
      Response response = await _dio.get('collections/category/records',
          queryParameters: qParamt);
      CategoryModel productCategory =
          MapHandler.mapSingleObjectFromJson<CategoryModel>(
              response.data['items'], CategoryModel.fromJson);
      return productCategory;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }

  @override
  Future<List<ProductPropertyModel>> getProductProperties(
      String productId) async {
    final Map<String, String> qParamt = {'filter': 'product_id = "$productId"'};
    try {
      Response response = await _dio.get('collections/properties/records',
          queryParameters: qParamt);
      List<ProductPropertyModel> productProperies =
          MapHandler.mapForJsonToModelList<ProductPropertyModel>(
              response.data['items'], ProductPropertyModel.fromJson);
      return productProperies;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }
}
