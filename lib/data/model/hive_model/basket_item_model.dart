import 'package:hive_flutter/hive_flutter.dart';

part 'basket_item_model.g.dart';

@HiveType(typeId: 0)
class BasketItemModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? collectionId;
  @HiveField(2)
  String? thumbnail;
  @HiveField(3)
  int discountPrice;
  @HiveField(4)
  int price;
  @HiveField(5)
  String? name;
  @HiveField(6)
  String? categoryId;
  @HiveField(7)
  int? realPrice;
  @HiveField(8)
  num? percent;
  BasketItemModel(
    this.id,
    this.collectionId,
    this.thumbnail,
    this.discountPrice,
    this.price,
    this.name,
    this.categoryId,
  ) {
    realPrice = price - discountPrice;
    percent = ((price - realPrice!) / price) * 100;
  }
}
