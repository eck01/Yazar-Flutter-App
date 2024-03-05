import 'package:yazar/model/book.dart';
import 'package:yazar/model/chapter.dart';

abstract class DatabaseBase {
  Future<dynamic> createBook(Book object);
  Future<List<Book>> readBooks(int index);
  Future<int> updateBook(Book object);
  Future<int> deleteBooks(List<dynamic> indexList);
  Future<dynamic> createChapter(Chapter object);
  Future<List<Chapter>> readChapters(dynamic bookId);
  Future<int> updateChapter(Chapter object);
  Future<int> deleteChapter(Chapter object);
}
