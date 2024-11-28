import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/data/repositories/category_product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ICategoryByProductRepository _categoryByProductRepository;
  ProductListBloc(this._categoryByProductRepository)
      : super(ProductInitList()) {
    on<ProductListRequest>(
      (event, emit) => _loadProductList(event.categoryId, emit),
    );
  }

  Future<void> _loadProductList(
      String categoryId, Emitter<ProductListState> emit) async {
    emit(ProductListLoading());

    final Either<String, List<ProductModel>> categoryByProductList =
        await _categoryByProductRepository
            .getCategorayByProductList(categoryId);

    emit(ProductListResponse(categoryByProductList));
  }
}
