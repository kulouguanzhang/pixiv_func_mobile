import 'dart:convert';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pixiv_dart_api/model/message_thread.dart';
import 'package:sqflite/sqflite.dart';

class ChatService extends GetxService {
  late final Database _database;
  static const _databaseName = 'chat.db';
  static const _tableName = 'chat';

  Future<ChatService> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (Database db, int version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName
          (
              id          INTEGER   NOT NULL CONSTRAINT ${_tableName}_pk  PRIMARY KEY AUTOINCREMENT,
              user_id     INTEGER   NOT NULL,
              thread_id   INTEGER   NOT NULL,
              modified_at TIMESTAMP NOT NULL,
              data_json   TEXT
          );
          CREATE UNIQUE INDEX ${_tableName}_id_uindex ON $_tableName (id);
          CREATE UNIQUE INDEX ${_tableName}_user_id_uindex ON $_tableName (user_id);
          CREATE UNIQUE INDEX ${_tableName}_thread_id_uindex ON $_tableName (thread_id);
          ''',
        );
      },
      version: 1,
    );
    return this;
  }

  Future<int> insert({required int userId, required MessageThread thread}) {
    return _database.insert(
      _tableName,
      {
        'thread_id': int.parse(thread.threadId),
        'user_id': userId,
        'data_json': jsonEncode(thread.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertAll({required int userId, required List<MessageThread> threads}) async {
    final batch = _database.batch();
    for (final thread in threads) {
      batch.insert(
        _tableName,
        {
          'thread_id': int.parse(thread.threadId),
          'user_id': userId,
          'data_json': jsonEncode(thread.toJson()),
          'modified_at': thread.modifiedAt,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return (await batch.commit()).length;
  }

  Future<List<MessageThread>> query({int? offset, int? limit}) async {
    final result = await _database.query(
      _tableName,
      offset: offset,
      limit: limit,
      // orderBy: 'modified_at DESC',
    );
    return result.map((e) => MessageThread.fromJson(jsonDecode(e['data_json'] as String))).toList();
  }

  Future<bool> update({required MessageThread thread}) async {
    return await _database.update(
          _tableName,
          {
            'modified_at': thread.modifiedAt,
            'data_json': jsonEncode(thread.toJson()),
          },
          where: 'thread_id = ?',
          whereArgs: [int.parse(thread.threadId)],
        ) >
        0;
  }

  Future<bool> exist({required MessageThread thread}) async {
    final result = await _database.rawQuery('SELECT 1 FROM $_tableName WHERE thread_id = ?', [int.parse(thread.threadId)]);
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
