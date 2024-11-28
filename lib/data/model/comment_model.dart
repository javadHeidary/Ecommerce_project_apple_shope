class CommentModel {
  String? id;
  String? productId;
  String? text;
  String? userId;
  String? userThumbnailUrl;
  String? userName;
  String? name;
  String? avatar;

  CommentModel(
    this.id,
    this.productId,
    this.text,
    this.userId,
    this.userThumbnailUrl,
    this.userName,
    this.name,
    this.avatar,
  );

  factory CommentModel.fromJson(Map<String, dynamic> jsonObject) {
    return CommentModel(
      jsonObject['id'],
      jsonObject['product_id'],
      jsonObject['text'],
      jsonObject['user_id'],
      'http://startflutter.ir/api/files/${jsonObject['expand']['user_id']['collectionName']}/${jsonObject['expand']['user_id']['id']}/${jsonObject['expand']['user_id']['avatar']}',
      jsonObject['expand']['user_id']['username'],
      jsonObject['expand']['user_id']['name'],
      jsonObject['expand']['user_id']['avatar'],
    );
  }
}
