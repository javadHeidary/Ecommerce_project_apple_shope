import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shop/data/model/hive_model/basket_item_model.dart';
import 'package:shop/data/repositories/basket_repository.dart';

part 'basket_event.dart';
part 'basket_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final IBasketRepository _basketRepository;
  BasketBloc(this._basketRepository) : super(BasketInit()) {
    on<BasketInitRequest>(
      (event, emit) => _loadBasketRequest(event, emit),
    );

    on<BasketRemoveProductRequest>(
      (event, emit) => _removeProductRequest(event.index, emit),
    );
  }

  Future<void> _loadBasketRequest(
      BasketInitRequest event, Emitter<BasketState> emit) async {
    emit(
      BasketLoading(),
    );

    final response = await Future.wait(
      [
        _basketRepository.getAllBasketItem(),
        _basketRepository.getFinalPrice(),
      ],
    );

    emit(
      BasketResponse(
        response[0] as Either<String, List<BasketItemModel>>,
        response[1] as Either<String, int>,
      ),
    );
  }

  Future<void> _removeProductRequest(
      int index, Emitter<BasketState> emit) async {
    emit(
      BasketLoading(),
    );

    final response = await Future.wait(
      [
        _basketRepository.removeFromBasket(index),
        _basketRepository.getAllBasketItem(),
        _basketRepository.getFinalPrice(),
      ],
    );
    emit(
      BasketRemoveProductResponsee(
        response[0] as Either<String, String>,
      ),
    );
    emit(
      BasketResponse(
        response[1] as Either<String, List<BasketItemModel>>,
        response[2] as Either<String, int>,
      ),
    );
  }
}
