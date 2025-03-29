// Import necessary packages for database and path handling
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as devtools show log;
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
    List<Map<String, dynamic>> existingUser =
        await db.query('users', where: 'email = ?', whereArgs: [user.email]);

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

  // Print all users for debugging purposes
  Future logAllUsers() async {
    Database db = await instance.db;
    // Get all users from db
    List<Map<String, Object?>> users = await db.query('users');

    for (var user in users) {
      // convert each user to a string and log it 
      devtools.log(user.toString());
    }
  }

  // Update an existing user in the database
  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Delete a user from the database by their ID
  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all users from users table
  Future clearUsers() async {
    Database db = await instance.db;
    await db.execute('''
    DELETE FROM users;
      ''');
  }
}
