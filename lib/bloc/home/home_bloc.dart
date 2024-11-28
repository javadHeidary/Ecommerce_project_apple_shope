import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shop/data/model/bannner_model.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/data/model/product_model.dart';
import 'package:shop/data/repositories/banner_repository.dart';
import 'package:shop/data/repositories/categoray_repository.dart';
import 'package:shop/data/repositories/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository _bannerRepository;
  final ICategorayRepository _categorayRepository;
  final IProductRepository _productRepository;

  HomeBloc(
    this._bannerRepository,
    this._categorayRepository,
    this._productRepository,
  ) : super(HomeInitial()) {
    on<HomeInitRequest>(
      (event, emit) => _loadHomeInitRequest(event, emit),
    );
  }

  Future<void> _loadHomeInitRequest(
    HomeInitRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      HomeLoading(),
    );

    final response = await Future.wait(
      [
        _bannerRepository.getBannerList(),
        _categorayRepository.getCategorayList(),
        _productRepository.getMostViewProductList(),
        _productRepository.getMostSellerProductList(),
      ],
    );

    emit(
      HomeResponse(
        response[0] as Either<String, List<BannerModel>>,
        response[1] as Either<String, List<CategoryModel>>,
        response[2] as Either<String, List<ProductModel>>,
        response[3] as Either<String, List<ProductModel>>,
      ),
    );
  }
}
