import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/basket_datasource.dart';
import 'package:shop/data/model/hive_model/basket_item_model.dart';

abstract class IBasketRepository {
  Future<Either<String, String>> addToBasket(BasketItemModel basketItem);
  Future<Either<String, List<BasketItemModel>>> getAllBasketItem();
  Future<Either<String, int>> getFinalPrice();
  Future<Either<String, String>> removeFromBasket(int index);
}

class BasketRepositoty extends IBasketRepository {
  final IBasketDatasource _basketDatasource;
  BasketRepositoty(this._basketDatasource);
  @override
  Future<Either<String, String>> addToBasket(BasketItemModel basketItem) async {
    try {
      await _basketDatasource.addtoBasket(basketItem);
      return right('محصول به سبد خرید اضافه شد');
    } catch (ex) {
      return left('خطا در افزودن محصول به سبد خرید');
    }
  }

  @override
  Future<Either<String, List<BasketItemModel>>> getAllBasketItem() async {
    try {
      List<BasketItemModel> basketItemList =
          await _basketDatasource.getAllBasketItem();
      return right(basketItemList);
    } catch (ex) {
      return left('خطا در نمایش محصولات');
    }
  }

  @override
  Future<Either<String, int>> getFinalPrice() async {
    try {
      int finalPrice = await _basketDatasource.getFinalPrice();
      return right(finalPrice);
    } catch (ex) {
      return left('خطا در نمایش قیمت');
    }
  }

  @override
  Future<Either<String, String>> removeFromBasket(int index) async {
    try {
      await _basketDatasource.removefromBasket(index);
      return right('محصول حذف شد');
    } catch (ex) {
      return left('مشکلی پیش امده دوباره امتحان کنید');
    }
  }
}
