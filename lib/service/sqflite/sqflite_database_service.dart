import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yazar/model/book.dart';
import 'package:yazar/model/chapter.dart';
import 'package:yazar/service/base/database_service.dart';

class SqfliteDatabaseService implements DatabaseService {
  Database? _database;

  final String _booksTable = 'books';
  final String _booksId = 'id';
  final String _booksName = 'name';
  final String _booksPublicationYear = 'publicationYear';
  final String _booksCategory = 'category';

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
          $_booksCategory INTEGER DEFAULT 0
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
      'ALTER TABLE $_booksTable ADD COLUMN $_booksCategory INTEGER DEFAULT 0',
    ];

    for (int index = oldVersion - 1; index < newVersion - 1; index++) {
      await database.execute(sqlList[index]);
    }
  }

  @override
  Future createBook(Book object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.insert(_booksTable, _objectToMap(object));
    } else {
      return -1;
    }
  }

  @override
  Future<List<Book>> readBooks(int index) async {
    Database? database = await _fetchDatabase();
    String? sqlWhere;
    List<dynamic>? sqlWhereArgs;
    List<Book> list = [];

    if (index >= 0) {
      sqlWhere = '$_booksCategory = ?';
      sqlWhereArgs = [index];
    }

    if (database != null) {
      List<Map<String, dynamic>> dataList = await database.query(
        _booksTable,
        where: sqlWhere,
        whereArgs: sqlWhereArgs,
        orderBy: '$_booksName collate localized',
      );

      for (Map<String, dynamic> dataMap in dataList) {
        Book object = _mapToObject(dataMap);
        list.add(object);
      }
    }

    return list;
  }

  Book _mapToObject(Map<String, dynamic> map) {
    Map<String, dynamic> dataMap = Map.from(map);
    int? dateTime = dataMap['publicationYear'];
    if (dateTime != null) {
      dataMap['publicationYear'] = DateTime.fromMillisecondsSinceEpoch(dateTime);
    }
    return Book.fromMap(dataMap);
  }

  @override
  Future<int> updateBook(Book object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.update(
        _booksTable,
        _objectToMap(object),
        where: '$_booksId = ?',
        whereArgs: [object.id],
      );
    } else {
      return 0;
    }
  }

  Map<String, dynamic> _objectToMap(Book object) {
    Map<String, dynamic> dataMap = object.toMap();
    DateTime? dateTime = dataMap['publicationYear'];
    if (dateTime != null) {
      dataMap['publicationYear'] = dateTime.millisecondsSinceEpoch;
    }
    return dataMap;
  }

  @override
  Future<int> deleteBooks(List indexList) async {
    Database? database = await _fetchDatabase();

    if (database != null && indexList.isNotEmpty) {
      String sqlWhere = '$_booksId in (';

      for (int i = 0; i < indexList.length; i++) {
        if (i != indexList.length - 1) {
          sqlWhere += '?,';
        } else {
          sqlWhere += '?)';
        }
      }

      return await database.delete(
        _booksTable,
        where: sqlWhere,
        whereArgs: indexList,
      );
    } else {
      return 0;
    }
  }

  @override
  Future createChapter(Chapter object) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.insert(_chaptersTable, object.toMap());
    } else {
      return -1;
    }
  }

  @override
  Future<List<Chapter>> readChapters(bookId) async {
    Database? database = await _fetchDatabase();
    List<Chapter> list = [];

    if (database != null) {
      List<Map<String, dynamic>> dataList = await database.query(
        _chaptersTable,
        where: '$_chaptersBookId = ?',
        whereArgs: [bookId],
      );

      for (Map<String, dynamic> dataMap in dataList) {
        Chapter object = Chapter.fromMap(dataMap);
        list.add(object);
      }
    }

    return list;
  }

  @override
  Future<int> updateChapter(Chapter object) async {
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

  @override
  Future<int> deleteChapter(Chapter object) async {
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
