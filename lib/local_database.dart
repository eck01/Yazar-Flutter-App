import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yazar/model/book_model.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();

  static final LocalDatabase _object = LocalDatabase._privateConstructor();

  factory LocalDatabase() {
    return _object;
  }

  Database? _database;

  final String _tableBooks = 'books';
  final String _columnId = 'id';
  final String _columnName = 'name';
  final String _columnPublicationYear = 'publicationYear';

  Future<Database?> _fetchDatabase() async {
    if (_database == null) {
      String filePath = await getDatabasesPath();
      String databasePath = join(filePath, 'yazar.db');
      _database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: _openDatabaseOnCreate,
      );
    }
    return _database;
  }

  Future<void> _openDatabaseOnCreate(Database database, int version) async {
    await database.execute(
      '''
        CREATE TABLE $_tableBooks (
          $_columnId	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
          $_columnName	TEXT NOT NULL,
          $_columnPublicationYear	INTEGER
        );
      ''',
    );
  }

  Future<int> create(BookModel book) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.insert(_tableBooks, book.toMap());
    } else {
      return -1;
    }
  }

  Future<List<BookModel>> read() async {
    Database? database = await _fetchDatabase();
    List<BookModel> list = [];

    if (database != null) {
      List<Map<String, dynamic>> dataList = await database.query(_tableBooks);
      for (Map<String, dynamic> dataMap in dataList) {
        BookModel book = BookModel.fromMap(dataMap);
        list.add(book);
      }
    }

    return list;
  }

  Future<int> update(BookModel book) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.update(
        _tableBooks,
        book.toMap(),
        where: '$_columnId = ?',
        whereArgs: [book.id],
      );
    } else {
      return 0;
    }
  }

  Future<int> delete(BookModel book) async {
    Database? database = await _fetchDatabase();

    if (database != null) {
      return await database.delete(
        _tableBooks,
        where: '$_columnId = ?',
        whereArgs: [book.id],
      );
    } else {
      return 0;
    }
  }
}
