import 'package:yazar/local_database.dart';
import 'package:yazar/model/chapter.dart';

class ChapterDetailViewModel {
  ChapterDetailViewModel(this._object);

  final Chapter _object;
  final LocalDatabase _database = LocalDatabase();

  Future<void> _updateContent(String content) async {
    _object.content = content;
    await _database.updateChapter(_object);
  }
}
