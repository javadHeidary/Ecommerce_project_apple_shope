import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/data/model/hive_model/basket_item_model.dart';
import 'package:shop/data/model/product_image_model.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/data/model/product_property_model.dart';
import 'package:shop/data/model/product_variant_model.dart';
import 'package:shop/data/repositories/basket_repository.dart';
import 'package:shop/data/repositories/product_detial_repository.dart';

part 'product_detial_event.dart';
part 'product_detial_state.dart';

class ProductDetialBloc extends Bloc<ProductDetialEvent, ProductDetialState> {
  final IProductDetialRepository _detialRepository;
  final IBasketRepository _basketRepository;

  ProductDetialBloc(this._detialRepository, this._basketRepository)
      : super(ProductInitDetial()) {
    on<ProductDetialInitRequest>(
      (event, emit) =>
          _loadProductDetails(event.categoryId, event.productId, emit),
    );
    on<ProductAddToBasketRequest>(
      (event, emit) => _addToBasket(event, emit),
    );
  }

  Future<void> _loadProductDetails(
    String categoryId,
    String productId,
    Emitter<ProductDetialState> emit,
  ) async {
    emit(
      ProductDetialLoading(),
    );

    final responses = await Future.wait(
      [
        _detialRepository.getProductCategory(categoryId),
        _detialRepository.getProductImageList(productId),
        _detialRepository.getProductVaraintList(productId),
        _detialRepository.getProductProperties(productId),
      ],
    );

    emit(
      ProductDetialResponse(
        responses[0] as Either<String, CategoryModel>,
        responses[1] as Either<String, List<ProductImageModel>>,
        responses[2] as Either<String, List<ProductVariantModel>>,
        responses[3] as Either<String, List<ProductPropertyModel>>,
      ),
    );
  }

  Future<void> _addToBasket(
      ProductAddToBasketRequest event, Emitter<ProductDetialState> emit) async {
    await _basketRepository.addToBasket(
      BasketItemModel(
        event.product.id,
        event.product.collectionId,
        event.product.thumbnail,
        event.product.discountPrice,
        event.product.price,
        event.product.name,
        event.product.category,
      ),
    );
  }
}
