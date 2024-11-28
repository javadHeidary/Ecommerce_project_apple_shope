class ProductImageModel {
  String? urlImage;
  String? productID;

  ProductImageModel(
    this.urlImage,
    this.productID,
  );

  factory ProductImageModel.fromJson(Map<String, dynamic> jsonObject) {
    return ProductImageModel(
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['image']}',
      jsonObject['product_id'],
    );
  }
}
