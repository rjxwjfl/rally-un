import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteConfigs {
  static final SqfliteConfigs instance = SqfliteConfigs._();
  static Database? _db;

  SqfliteConfigs._();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'rally.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onCreate(Database db, int ver) async {
    await db.execute('''
      CREATE TABLE todo (
        todo_id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        desc TEXT,
        priority INTEGER NOT NULL,
        state INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        created_date TEXT NOT NULL,
        updated_date TEXT NOT NULL,
        completed_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE storage (
        storage_id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        icon INTEGER NOT NULL,
        type INTEGER NOT NULL,
        created_date TEXT NOT NULL,
        updated_date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE todo_storage (
        storage_id INTEGER NOT NULL,
        todo_id INTEGER NOT NULL
      )
    ''');

    // 아카이브 테이블 생성
    await db.execute('''
      CREATE TABLE todo_archive (
        todo_id INTEGER,
        title TEXT NOT NULL,
        desc TEXT,
        priority INTEGER NOT NULL,
        state INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        created_date TEXT NOT NULL,
        updated_date TEXT NOT NULL,
        completed_date TEXT,
        deleted_date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE storage_archive (
        storage_id INTEGER,
        title TEXT NOT NULL,
        icon INTEGER NOT NULL,
        type INTEGER NOT NULL,
        created_date TEXT NOT NULL,
        updated_date TEXT NOT NULL,
        deleted_date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE todo_storage_archive (
        storage_id INTEGER NOT NULL,
        todo_id INTEGER NOT NULL,
        deleted_date TEXT NOT NULL
      )
    ''');
  }

  void _onUpgrade(Database db, int oldV, int newV) async {}

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
