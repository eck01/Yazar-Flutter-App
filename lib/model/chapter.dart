import 'package:flutter/material.dart';

class Chapter with ChangeNotifier {
  Chapter(this.bookId, this.title) : content = '';

  dynamic id;
  int bookId;
  String title;
  String content;

  Chapter.fromMap(Map<String, dynamic> map)
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

  void update(String value) {
    title = value;
    notifyListeners();
  }
}
