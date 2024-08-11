import 'package:rally/configs/sqflite_configs.dart';
import 'package:rally/dto/schedule/storage_req_dto.dart';
import 'package:rally/dto/schedule/storage_resp_dto.dart';
import 'package:rally/util/datetime_convert.dart';

class SqfStorageRepository {
  final SqfliteConfigs _db = SqfliteConfigs.instance;

  Future<int> createStorage({required StorageReqDto data}) async {
    String date = sqlDateFormat(DateTime.now());
    final db = await _db.database;
    int id = await db.insert('storage', {
      ...data.toMap(),
      'created_date': date,
      'updated_date': date,
    });

    return id;
  }

  Future<List<StorageRespDto>> getStorageList() async {
    final db = await _db.database;
    List<dynamic> init = await db.query('storage');
    return init.map((e) => StorageRespDto.fromMap(e)).toList();
  }

  Future<void> updateStorage({required int storageId, required StorageReqDto data}) async {
    String date = sqlDateFormat(DateTime.now());
    final db = await _db.database;
    await db.update(
      'storage',
      {
        ...data.toMap(),
        'updated_date': date,
      },
      where: 'storage_id = ?',
      whereArgs: [storageId],
    );
  }

  Future<void> deleteStorage({required int storageId}) async {
    // String date = sqlDateFormat(DateTime.now());
    final db = await _db.database;

    await db.transaction((txn) async {
      // // 링크된 모든 todo를 아카이브 테이블로 이동
      // await txn.rawInsert('''
      //   INSERT INTO todo_archive
      //   SELECT *, ? AS deleted_date
      //   FROM todo
      //   WHERE todo_id IN (
      //     SELECT todo_id
      //     FROM todo_storage
      //     WHERE storage_id = ?
      //   )
      // ''', [date, storageId]);
      //
      // // 링크된 모든 todo_storage를 아카이브 테이블로 이동
      // await txn.rawInsert('''
      //   INSERT INTO todo_storage_archive
      //   SELECT *, ? AS deleted_date
      //   FROM todo_storage
      //   WHERE storage_id = ?
      // ''', [date, storageId]);
      //
      // // 스토리지 데이터를 아카이브 테이블로 이동
      // await txn.rawInsert('''
      //   INSERT INTO storage_archive
      //   SELECT *, ? AS deleted_date
      //   FROM storage
      //   WHERE storage_id = ?
      // ''', [date, storageId]);

      // 원본 테이블에서 데이터 삭제
      await txn.rawDelete('''
        DELETE FROM todo
        WHERE todo_id IN (
          SELECT todo_id
          FROM todo_storage
          WHERE storage_id = ?
        )
      ''', [storageId]);

      await txn.rawDelete('''
        DELETE FROM todo_storage
        WHERE storage_id = ?
      ''', [storageId]);

      await txn.rawDelete('''
        DELETE FROM storage
        WHERE storage_id = ?
      ''', [storageId]);
    });
  }

  Future<void> _restoreStorage({required int storageId}) async {
    final db = await _db.database;

    await db.transaction((txn) async {
      // 먼저 아카이브 테이블에서 storage 데이터를 가져와 원본 테이블로 이동
      await txn.rawInsert('''
      INSERT INTO storage
      SELECT storage_id, title, icon, type, created_date, updated_date
      FROM storage_archive
      WHERE storage_id = ?
    ''', [storageId]);

      // 관련된 todo_storage 데이터도 복구
      await txn.rawInsert('''
      INSERT INTO todo_storage
      SELECT storage_id, todo_id
      FROM todo_storage_archive
      WHERE storage_id = ?
    ''', [storageId]);

      // 아카이브 테이블에서 해당 storage 데이터 삭제
      await txn.delete(
        'storage_archive',
        where: 'storage_id = ?',
        whereArgs: [storageId],
      );

      await txn.delete(
        'todo_storage_archive',
        where: 'storage_id = ?',
        whereArgs: [storageId],
      );
    });
  }
}
