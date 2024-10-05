import 'dart:async';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqf_lite_crude/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DbService {

  static final DbService _dbService = DbService._internal();
  factory DbService() => _dbService;
  DbService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = '${getDirectory.path}/user.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version ) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS USER(id TEXT PRIMARY KEY, name TEXT, email TEXT, image STRING)',
    );
    log('USER TABLE CREATED');

    // Creating AUTH table for login/signup
    await db.execute(
      'CREATE TABLE IF NOT EXISTS AUTH(id TEXT PRIMARY KEY, userName TEXT, userEmail TEXT, userPassword TEXT, isLogin INTEGER)',
    );
    log('AUTH TABLE CREATED');

  }


  // Signup method for inserting user data into AUTH table
  Future<void> insertAuthData(Map<String, dynamic> user) async {
    final authDb = await _dbService.database;
    try {
       log('Inserting user into AUTH table: $user');

      var data = await authDb.insert('AUTH', user, conflictAlgorithm: ConflictAlgorithm.replace);

      log('User registered with ID: $data');
    } catch (e) {
      log('Error during sign-up: $e');
    }
  }


  // SignIn method for inserting user data into AUTH table
  Future<List<Map<String, dynamic>>> getAuthData()async{
        final db = await  _dbService.database;
        return await db.query('AUTH');
  }

  Future<void> updateAuthData(String?id, Map<String, dynamic> updateAuth)async{
    final db = await _dbService.database;
    await db.update(
        'AUTH',
        updateAuth,
        where: 'id = ?',
        whereArgs: [id]
    );
  }


  // Insert method for user details in USER table
  Future<void> insertUser(UserModel user) async {
    final db = await _dbService.database;
    try {
      var data = await db.rawInsert(
        'INSERT INTO USER(id, name, email, image) VALUES(?, ?, ?, ?)',
        [user.id, user.name, user.email, user.image],
      );
      log('User inserted with ID: $data');
    } catch (e) {
      log('Error during insert: $e');
    }
  }


  // Fetch all user data
  Future<List<UserModel>> getUserData() async {
    final db = await _dbService.database;
    try {
      var data = await db.rawQuery('SELECT * FROM USER');
      List<UserModel> users = List.generate(data.length, (index) => UserModel.fromJson(data[index]),);

      log('Retrieved ${users.length} users');
      return users;
    } catch (e) {
      log('Error during fetch: $e');
      return [];
    }
  }


  // Update user details
  Future<void> updateUserData(UserModel user) async {
    final db = await _dbService.database;
    try {
      var data = await db.rawUpdate(
        'UPDATE USER SET name=?, email=?, image=? WHERE id=?',
        [user.name, user.email, user.image, user.id],
      );
      log('User updated with ID: $data');
      await getUserData();
    } catch (e) {
      log('Error during update: $e');
    }
  }


  // Delete user data
  Future<void> deleteUserData(String id) async {
    final db = await _dbService.database;
    try {
      var data = await db.rawDelete('DELETE FROM USER WHERE id=?', [id]);
      log('User deleted with ID: $data');
    } catch (e) {
      log('Error during delete: $e');
    }
  }


}
