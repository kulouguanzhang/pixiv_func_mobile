import 'dart:convert';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:sqflite/sqflite.dart';

class HistoryService extends GetxService {
  late final Database _database;
  static const _databaseName = 'history.db';
  static const _tableName = 'history';

  Future<HistoryService> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (Database db, int version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName
          (
            id        INTEGER NOT NULL CONSTRAINT ${_tableName}_pk PRIMARY KEY AUTOINCREMENT,
            illust_id INTEGER NOT NULL,
            data_json TEXT NOT NULL
          );
          CREATE UNIQUE INDEX ${_tableName}_id_uindex ON $_tableName (id);
          CREATE UNIQUE INDEX ${_tableName}_illust_id_uindex ON $_tableName (illust_id);
          ''',
        );
      },
      version: 1,
    );
    return this;
  }

  Future<int> insert(Illust illust) {
    return _database.insert(
        _tableName,
        {
          'illust_id': illust.id,
          'data_json': jsonEncode(illust.toJson()),
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Illust>> query(int offset, int limit) async {
    final result = await _database.query(
      _tableName,
      offset: offset,
      limit: limit,
      orderBy: 'id DESC',
    );
    return result.map((e) => Illust.fromJson(jsonDecode(e['data_json'] as String))).toList();
  }

  Future<int> delete(int illustId) {
    return _database.delete(_tableName, where: 'illust_id = ?', whereArgs: [illustId]);
  }

  Future<bool> exist(int illustId) async {
    final result = await _database.rawQuery('SELECT 1 FROM $_tableName WHERE illust_id = ?', [illustId]);
    return result.isNotEmpty;
  }

  Future<int> count() async {
    final result = await _database.rawQuery('SELECT COUNT(id) FROM $_tableName');
    return Sqflite.firstIntValue(result) as int;
  }

  Future<void> clear() {
    final batch = _database.batch();
    batch.delete(_tableName);
    batch.delete('sqlite_sequence', where: 'name = ?', whereArgs: [_tableName]);
    return batch.commit();
  }
}
