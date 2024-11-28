class ProductModel {
  String? id;
  String? collectionId;
  String? thumbnail;
  String? description;
  int discountPrice;
  int price;
  String? polularity;
  String? name;
  int? quantity;
  String? category;
  int? realPrice;
  num? percent;
  ProductModel(
    this.id,
    this.collectionId,
    this.thumbnail,
    this.description,
    this.discountPrice,
    this.price,
    this.polularity,
    this.name,
    this.quantity,
    this.category,
  ) {
    realPrice = price - discountPrice;
    percent = ((price - realPrice!) / price) * 100;
  }
  factory ProductModel.fromJson(Map<String, dynamic> jsonObject) {
    return ProductModel(
      jsonObject['id'],
      jsonObject['collectionId'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['description'],
      jsonObject['discount_price'],
      jsonObject['price'],
      jsonObject['polularity'],
      jsonObject['name'],
      jsonObject['quantity'],
      jsonObject['category'],
    );
  }
}
