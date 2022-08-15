import 'dart:convert';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pixiv_dart_api/model/message_thread_content.dart';
import 'package:sqflite/sqflite.dart';

class MessageService extends GetxService {
  late final Database _database;
  static const _databaseName = 'message.db';
  static const _tableName = 'message';

  Future<MessageService> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (Database db, int version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName
          (
              id          INTEGER   NOT NULL
                  CONSTRAINT ${_tableName}_pk
                      PRIMARY KEY AUTOINCREMENT,
              thread_id   INTEGER      NOT NULL,
              content_id  INTEGER   NOT NULL,
              create_at   TIMESTAMP   NOT NULL,
              data_json   TEXT
          );
          CREATE UNIQUE INDEX ${_tableName}_id_uindex ON $_tableName (id);
          CREATE UNIQUE INDEX ${_tableName}_content_id_uindex ON $_tableName (content_id);
          ''',
        );
      },
      version: 1,
    );
    return this;
  }

  Future<int> insert({required int threadId, required MessageThreadContent message}) {
    return _database.insert(
      _tableName,
      {
        'thread_id': threadId,
        'content_id': int.parse(message.contentId),
        'data_json': jsonEncode(message.toJson()),
        'create_at': message.createAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertAll({required int threadId, required List<MessageThreadContent> messages}) async {
    final batch = _database.batch();
    for (final message in messages) {
      batch.insert(
        _tableName,
        {
          'thread_id': threadId,
          'content_id': int.parse(message.contentId),
          'data_json': jsonEncode(message.toJson()),
          'create_at': message.createAt,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return (await batch.commit()).length;
  }

  Future<List<MessageThreadContent>> query({required int threadId, int? offset, int? limit}) async {
    final result = await _database.query(
      _tableName,
      offset: offset,
      limit: limit,
      where: 'thread_id = ?',
      whereArgs: [threadId],
      orderBy: 'create_at DESC',
    );
    return result.map((e) => MessageThreadContent.fromJson(jsonDecode(e['data_json'] as String))).toList();
  }

  Future<bool> update(MessageThreadContent content) async {
    return await _database.update(
          _tableName,
          {
            'create_at': content.createAt,
            'data_json': jsonEncode(content.toJson()),
          },
          where: 'content_id = ?',
          whereArgs: [int.parse(content.contentId)],
        ) >
        0;
  }

  Future<bool> exist(String threadId) async {
    final result = await _database.rawQuery('SELECT 1 FROM $_tableName WHERE content_id = ?', [int.parse(threadId)]);
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
