import 'package:flutter/material.dart';
import 'package:yazar/model/chapter.dart';
import 'package:yazar/repository/database_repository.dart';
import 'package:yazar/tools/locator.dart';

class ChapterDetailViewModel with ChangeNotifier {
  ChapterDetailViewModel(this._object);

  final Chapter _object;
  Chapter get object => _object;

  final DatabaseRepository _databaseRepository = locator<DatabaseRepository>();

  Future<void> updateContent(String content) async {
    _object.content = content;
    await _databaseRepository.updateChapter(_object);
  }
}
