import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/User.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _db;
  static final String tableName = "login";

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    return _db ??= await initDb();
  }


  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "loja.db");
    
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        String sql = """
            CREATE TABLE login( 
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome VARCHAR NOT NULL,
              email VARCHAR NOT NULL,
              password VARCHAR NOT NULL
            );""";
         await db.execute(sql);

      }
    );

    return db;
  }

  Future<int> insertUser(User user) async{
    var database = await db;

    int result = await database.insert(tableName, user.toMap());

    return result;

  }


}