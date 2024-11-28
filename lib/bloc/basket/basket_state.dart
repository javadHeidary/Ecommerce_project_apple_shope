part of 'basket_bloc.dart';

sealed class BasketState {}

final class BasketInit extends BasketState {}

final class BasketLoading extends BasketState {}

final class BasketResponse extends BasketState {
  final Either<String, List<BasketItemModel>> basketItemList;
  final Either<String, int> basketFinalPrice;

  BasketResponse(
    this.basketItemList,
    this.basketFinalPrice,
  );
}

final class BasketRemoveProductResponsee extends BasketState {
  final Either<String, String> response;

  BasketRemoveProductResponsee(this.response);
}
