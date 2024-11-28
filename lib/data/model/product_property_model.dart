class ProductPropertyModel {
  String? id;
  String? productId;
  String? title;
  String? value;
  ProductPropertyModel(
    this.id,
    this.productId,
    this.title,
    this.value,
  );
  factory ProductPropertyModel.fromJson(Map<String, dynamic> jsonObject) {
    return ProductPropertyModel(
      jsonObject['id'],
      jsonObject['product_id'],
      jsonObject['title'],
      jsonObject['value'],
    );
  }
}
