import 'package:flutter/material.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/chapter.dart';

class ChapterDetailViewModel with ChangeNotifier {
  ChapterDetailViewModel(this._object);

  final Chapter _object;
  Chapter get object => _object;

  final LocalDatabase _database = LocalDatabase();

  Future<void> updateContent(String content) async {
    _object.content = content;
    await _database.updateChapter(_object);
  }
}
