import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    await database.query(
      '''
        CREATE TABLE $_tableBooks (
          $_columnId	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
          $_columnName	TEXT NOT NULL,
          $_columnPublicationYear	INTEGER
        );
      ''',
    );
  }
}
