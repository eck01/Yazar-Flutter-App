import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yazar/model/book_model.dart';
import 'package:yazar/model/chapter_model.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();

  static final LocalDatabase _object = LocalDatabase._privateConstructor();

  factory LocalDatabase() {
    return _object;
  }

  Database? _database;

  final String _booksTable = 'books';
  final String _booksId = 'id';
  final String _booksName = 'name';
  final String _booksPublicationYear = 'publicationYear';
  final String _bookCategory = 'category';

  final String _chaptersTable = 'chapters';
  final String _chaptersId = 'id';
  final String _chaptersBookId = 'bookId';
  final String _chaptersTitle = 'title';
  final String _chaptersContent = 'content';
  final String _chaptersPublicationYear = 'publicationYear';

  Future<Database?> _fetchDatabase() async {
    if (_database == null) {
      String filePath = await getDatabasesPath();
      String databasePath = join(filePath, 'yazar.db');
      _database = await openDatabase(
        databasePath,
        version: 2,
        onCreate: _openDatabaseOnCreate,
        onUpgrade: _openDatabaseOnUpgrade,
      );
    }
    return _database;
  }

  Future<void> _openDatabaseOnCreate(Database database, int version) async {
    await database.execute(
      '''
        CREATE TABLE $_booksTable (
          $_booksId	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
          $_booksName	TEXT NOT NULL,
          $_booksPublicationYear	INTEGER,
          $_bookCategory INTEGER DEFAULT 0
        );
      ''',
    );
    await database.execute(
      '''
        CREATE TABLE $_chaptersTable (
          $_chaptersId INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
          $_chaptersBookId INTEGER NOT NULL,
          $_chaptersTitle TEXT NOT NULL,
          $_chaptersContent TEXT,
          $_chaptersPublicationYear TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY("$_chaptersBookId") REFERENCES "$_booksTable"("$_booksId") ON UPDATE CASCADE ON DELETE CASCADE
        );
      ''',
    );
  }

  Future<void> _openDatabaseOnUpgrade(Database database, int oldVersion, int newVersion) async {
    List<String> sqlList = [
      'ALTER TABLE $_booksTable ADD COLUMN $_bookCategory INTEGER DEFAULT 0',
    ];

    for (int index = oldVersion - 1; index < newVersion - 1; index++) {
      await database.execute(sqlList[index]);
    }
  }

  Future<int> createBook(BookModel object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.insert(_booksTable, object.toMap());
    } else {
      return -1;
    }
  }

  Future<List<BookModel>> readBooks() async {
    Database? database = await _fetchDatabase();
    List<BookModel> list = [];

    if (database != null) {
      List<Map<String, dynamic>> dataList = await database.query(_booksTable);
      for (Map<String, dynamic> dataMap in dataList) {
        BookModel object = BookModel.fromMap(dataMap);
        list.add(object);
      }
    }

    return list;
  }

  Future<int> updateBook(BookModel object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.update(
        _booksTable,
        object.toMap(),
        where: '$_booksId = ?',
        whereArgs: [object.id],
      );
    } else {
      return 0;
    }
  }

  Future<int> deleteBook(BookModel object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.delete(
        _booksTable,
        where: '$_booksId = ?',
        whereArgs: [object.id],
      );
    } else {
      return 0;
    }
  }

  Future<int> createChapter(ChapterModel object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.insert(_chaptersTable, object.toMap());
    } else {
      return -1;
    }
  }

  Future<List<ChapterModel>> readChapters(int bookId) async {
    Database? database = await _fetchDatabase();
    List<ChapterModel> list = [];

    if (database != null) {
      List<Map<String, dynamic>> dataList = await database.query(
        _chaptersTable,
        where: '$_chaptersBookId = ?',
        whereArgs: [bookId],
      );

      for (Map<String, dynamic> dataMap in dataList) {
        ChapterModel object = ChapterModel.fromMap(dataMap);
        list.add(object);
      }
    }

    return list;
  }

  Future<int> updateChapter(ChapterModel object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.update(
        _chaptersTable,
        object.toMap(),
        where: '$_chaptersId = ?',
        whereArgs: [object.id],
      );
    } else {
      return 0;
    }
  }

  Future<int> deleteChapter(ChapterModel object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.delete(
        _chaptersTable,
        where: '$_chaptersId = ?',
        whereArgs: [object.id],
      );
    } else {
      return 0;
    }
  }
}
