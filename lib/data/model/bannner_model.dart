class BannerModel {
  String? id;
  String? collectionId;
  String? thumbnail;
  String? categoryId;
  BannerModel(
    this.id,
    this.collectionId,
    this.thumbnail,
    this.categoryId,
  );

  factory BannerModel.fromJson(Map<String, dynamic> jsonObject) {
    return BannerModel(
      jsonObject['id'],
      jsonObject['collectionId'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['categoryId'],
    );
  }
}
