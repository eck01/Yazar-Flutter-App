import 'package:get_it/get_it.dart';
import 'package:yazar/repository/database_repository.dart';
import 'package:yazar/service/sqflite/sqflite_database_service.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => DatabaseRepository());
  locator.registerLazySingleton(() => SqfliteDatabaseService());
}
