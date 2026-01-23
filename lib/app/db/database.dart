import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
part 'database.g.dart';

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get themeMode => boolean()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get token => text().nullable()();
}

@DriftDatabase(tables: [Settings, Users])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  /// Удаляет файл базы данных
  /// Удаление БД при изменении схемы в разработке
  static Future<void> deleteDatabase() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final dbFile = File('${directory.path}/settings_database.db');
      final dbShmFile = File('${directory.path}/settings_database.db-shm');
      final dbWalFile = File('${directory.path}/settings_database.db-wal');

      if (await dbFile.exists()) {
        await dbFile.delete();
        debugPrint('AppDatabase: удален файл БД: ${dbFile.path}');
      }
      if (await dbShmFile.exists()) {
        await dbShmFile.delete();
        debugPrint('AppDatabase: удален файл БД (shm): ${dbShmFile.path}');
      }
      if (await dbWalFile.exists()) {
        await dbWalFile.delete();
        debugPrint('AppDatabase: удален файл БД (wal): ${dbWalFile.path}');
      }
    } catch (e) {
      debugPrint('AppDatabase: ошибка при удалении БД: $e');
      rethrow;
    }
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'settings_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}