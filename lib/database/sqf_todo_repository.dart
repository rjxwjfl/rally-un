import 'package:rally/configs/sqflite_configs.dart';
import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_req_dto.dart';
import 'package:rally/util/datetime_convert.dart';

class SqfTodoRepository {
  final SqfliteConfigs _db = SqfliteConfigs.instance;

  Future<void> createTodo({required int storageId, required TodoReqDto data}) async {
    String date = sqlDateFormat(DateTime.now());
    final db = await _db.database;
    int id = await db.insert('todo', {
      ...data.toMap(),
      'created_date': date,
      'updated_date': date,
    });

    await db.insert('todo_storage', {'storage_id': storageId, 'todo_id': id});
  }

  Future<List<InternalTodoRespDto>> getTodoList({required int storageId}) async {
    final db = await _db.database;

    List<dynamic> data = await db.rawQuery('''
      SELECT 
        storage.title AS storage_title, 
        storage.icon, 
        storage.type,
        storage.created_date AS storage_created_date,
        storage.updated_date AS storage_updated_date,
        todo.todo_id, 
        todo.title, 
        todo.desc, 
        todo.priority, 
        todo.state,
        todo.start_date, 
        todo.end_date, 
        todo.completed_date,
        todo.created_date,
        todo.updated_date
      FROM todo
      INNER JOIN todo_storage ON todo.todo_id = todo_storage.todo_id
      INNER JOIN storage ON todo_storage.storage_id = storage.storage_id
      WHERE storage.storage_id = ?
    ''', [storageId]);

    return data.map((e) => InternalTodoRespDto.fromMap(e)).toList();
  }

  Future<void> updateTodo({required int todoId, required TodoReqDto data}) async {
    String date = sqlDateFormat(DateTime.now());
    final db = await _db.database;
    await db.update(
      'todo',
      {
        ...data.toMap(),
        'updated_date': date,
      },
      where: 'todo_id = ?',
      whereArgs: [todoId],
    );
  }

  Future<void> updateTodoState({required int todoId, required int state}) async {
    String date = sqlDateFormat(DateTime.now());
    final db = await _db.database;
    await db.update(
      'todo',
      {
        'state': state,
        'updated_date': date,
      },
      where: 'todo_id = ?',
      whereArgs: [todoId],
    );
  }

  Future<void> expiration() async {
    final db = await _db.database;
    String currentDate = sqlDateFormat(DateTime.now());

    // end_date가 지난 todo들의 상태를 expire(2)로 변경
    await db.update(
      'todo',
      {
        'state': 2, // expire 상태
        'updated_date': currentDate,
      },
      where: 'end_date < ? AND state == ?',
      whereArgs: [currentDate, 0], // 이미 만료 상태가 아닌 것들만 업데이트
    );
  }

  Future<void> deleteTodo({required int todoId}) async {
    // String date = sqlDateFormat(DateTime.now());
    final db = await _db.database;

    await db.transaction((txn) async {
      // // 먼저 todo 데이터를 아카이브 테이블로 이동
      // await txn.rawInsert('''
      //   INSERT INTO todo_archive
      //   SELECT *, ? AS deleted_date
      //   FROM todo
      //   WHERE todo_id = ?
      // ''', [date, todoId]);
      //
      // // 관련된 todo_storage 데이터도 아카이브 테이블로 이동
      // await txn.rawInsert('''
      //   INSERT INTO todo_storage_archive
      //   SELECT *, ? AS deleted_date
      //   FROM todo_storage
      //   WHERE todo_id = ?
      // ''', [date, todoId]);

      // 원본 테이블에서 todo 데이터 삭제
      await txn.delete(
        'todo_storage',
        where: 'todo_id = ?',
        whereArgs: [todoId],
      );

      await txn.delete(
        'todo',
        where: 'todo_id = ?',
        whereArgs: [todoId],
      );
    });
  }

  Future<void> _restoreTodo({required int todoId}) async {
    final db = await _db.database;

    await db.transaction((txn) async {
      // 먼저 아카이브 테이블에서 todo 데이터를 가져와 원본 테이블로 이동
      await txn.rawInsert('''
      INSERT INTO todo
      SELECT todo_id, title, desc, priority, state, start_date, end_date, created_date, updated_date, completed_date
      FROM todo_archive
      WHERE todo_id = ?
    ''', [todoId]);

      // 관련된 todo_storage 데이터도 복구
      await txn.rawInsert('''
      INSERT INTO todo_storage
      SELECT storage_id, todo_id
      FROM todo_storage_archive
      WHERE todo_id = ?
    ''', [todoId]);

      // 아카이브 테이블에서 해당 todo 데이터 삭제
      await txn.delete(
        'todo_archive',
        where: 'todo_id = ?',
        whereArgs: [todoId],
      );

      await txn.delete(
        'todo_storage_archive',
        where: 'todo_id = ?',
        whereArgs: [todoId],
      );
    });
  }
}
