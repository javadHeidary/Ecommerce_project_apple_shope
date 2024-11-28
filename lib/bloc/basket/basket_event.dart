part of 'basket_bloc.dart';

sealed class BasketEvent {}

final class BasketInitRequest extends BasketEvent {}

final class BasketRemoveProductRequest extends BasketEvent {
  final int index;

  BasketRemoveProductRequest(this.index);
}
