class CategoryModel {
  String? id;
  String? collectionId;
  String? thumbnail;
  String? title;
  String? color;
  String? icon;

  CategoryModel(
    this.id,
    this.collectionId,
    this.thumbnail,
    this.title,
    this.color,
    this.icon,
  );
  factory CategoryModel.fromJson(Map<String, dynamic> jsonObject) {
    return CategoryModel(
      jsonObject['id'],
      jsonObject['collectionId'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['title'],
      jsonObject['color'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['icon']}',
    );
  }
}
