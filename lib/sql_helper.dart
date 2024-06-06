import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            username TEXT,
            password TEXT,
            email TEXT,
            role TEXT
          )
        ''');
      },
    );
  }

  Future<void> newUser(String name, String username, String password,
      String email, String role) async {
    final db = await database;
    print(
        "Inserting user: $name, $username, $password, $email, $role"); // Debug log
    await db.insert(
      'Users',
      {
        'name': name,
        'username': username,
        'password': password,
        'email': email,
        'role': role
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'Users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<void> printUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('Users');
    for (var user in users) {
      print(
          'User: ${user['name']}, ${user['username']}, ${user['email']}, ${user['role']}');
    }
  }
}
