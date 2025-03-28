// Import necessary packages for database and path handling
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// Import user data model
import 'package:testapp/database/user.dart';


// DatabaseService class manages database operations for users
class DatabaseService {
  // Singleton instance of DatabaseService
  static final DatabaseService instance = DatabaseService._instance();
  
  // Static database instance to be shared across the application
  static Database? database;

  // Private constructor for singleton pattern
  DatabaseService._instance();

  // Getter for database, initializes if not already created
  Future<Database> get db async {
    database ??= await initDb();
    return database!;
  }

  // Initialize the database
  Future<Database> initDb() async {
    // Get the default databases path
    String dbPath = await getDatabasesPath();
    // Create full path for the database file
    String path = join(dbPath, 'auth.db');
    // Open the database, creating it if it doesn't exist
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the users table when the database is first created
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        passwordHash TEXT NOT NULL,
        createdAt TEXT NOT NULL 
      )
    ''');
  }

  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    Database db = await instance.db;
    return await db.insert('users', user.toMap());
  }

Future<int?> insertUserIfNotExists(User user) async {
  Database db = await instance.db;
  
  // First, check if the user already exists
  List<Map<String, dynamic>> existingUser = await db.query(
    'users', 
    where: 'email = ?', 
    whereArgs: [user.email]
  );
  
  // If no existing user is found, insert the new user
  if (existingUser.isEmpty) {
    return await db.insert('users', user.toMap());
  }
  
  // Return null if user already exists
  return null;
}

  // Retrieve all users from the database
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('users');
  }

  // Update an existing user in the database
  // NOTE: There's a typo in the table name ('gfg_users' instead of 'users')
  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db.update('gfg_users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Delete a user from the database by their ID
  // NOTE: There's a typo in the table name ('gfg_users' instead of 'users')
  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('gfg_users', where: 'id = ?', whereArgs: [id]);
  }
}

