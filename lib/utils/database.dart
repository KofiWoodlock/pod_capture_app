import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _authtableName = "auth";
  final String _authIdFieldName = "id";
  final String _authEmailFieldName = "email";
  final String _authPasswordFieldName = "passwordHash";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, "auth.db");
    final database = await openDatabase(dbPath, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $_authtableName (
        $_authIdFieldName INTEGER PRIMARY KEY AUTOINCREMENT,
        $_authEmailFieldName TEXT,
        $_authPasswordFieldName TEXT NOT NULL
        )''');
    });
    return database;
  }
}
