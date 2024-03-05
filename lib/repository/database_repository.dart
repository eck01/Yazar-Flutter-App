import 'package:yazar/base/database_base.dart';
import 'package:yazar/model/book.dart';
import 'package:yazar/model/chapter.dart';
import 'package:yazar/service/base/database_service.dart';
import 'package:yazar/service/sqflite/sqflite_database_service.dart';
import 'package:yazar/tools/locator.dart';

class DatabaseRepository implements DatabaseBase {
  final DatabaseService _service = locator<SqfliteDatabaseService>();

  @override
  Future createBook(Book object) async {
    return await _service.createBook(object);
  }

  @override
  Future<List<Book>> readBooks(int index) async {
    return await _service.readBooks(index);
  }

  @override
  Future<int> updateBook(Book object) async {
    return await _service.updateBook(object);
  }

  @override
  Future<int> deleteBooks(List indexList) async {
    return await _service.deleteBooks(indexList);
  }

  @override
  Future createChapter(Chapter object) async {
    return await _service.createChapter(object);
  }

  @override
  Future<List<Chapter>> readChapters(bookId) async {
    return await _service.readChapters(bookId);
  }

  @override
  Future<int> updateChapter(Chapter object) async {
    return await _service.updateChapter(object);
  }

  @override
  Future<int> deleteChapter(Chapter object) async {
    return await _service.deleteChapter(object);
  }
}
