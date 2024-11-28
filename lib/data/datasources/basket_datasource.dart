import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop/data/model/hive_model/basket_item_model.dart';

abstract class IBasketDatasource {
  Future<void> addtoBasket(BasketItemModel basketItem);
  Future<List<BasketItemModel>> getAllBasketItem();
  Future<void> removefromBasket(int index);
  Future<int> getFinalPrice();
}

class BasketLocal extends IBasketDatasource {
  final Box<BasketItemModel> _basketBox;
  BasketLocal(this._basketBox);
  @override
  Future<void> addtoBasket(BasketItemModel basketItem) async {
    await _basketBox.add(basketItem);
  }

  @override
  Future<int> getFinalPrice() async {
    List<BasketItemModel> basketItemList = _basketBox.values.toList();
    int finalPrice = basketItemList.fold(
        0,
        (accumulator, basketItemModel) =>
            accumulator + basketItemModel.realPrice!);
    return finalPrice;
  }

  @override
  Future<List<BasketItemModel>> getAllBasketItem() async {
    List<BasketItemModel> basketItemList = _basketBox.values.toList();
    return basketItemList;
  }

  @override
  Future<void> removefromBasket(int index) async {
    await _basketBox.deleteAt(index);
  }
}
