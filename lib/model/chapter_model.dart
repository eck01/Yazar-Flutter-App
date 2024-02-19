class ChapterModel {
  ChapterModel(this.bookId, this.title) : content = '';

  int? id;
  int bookId;
  String title;
  String content;

  ChapterModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        bookId = map['bookId'],
        title = map['title'],
        content = map['content'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'content': content,
    };
  }
}
