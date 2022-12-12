import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Anuncio.dart';

class AnuncioHelper {
  static final _anuncioHelper = AnuncioHelper.internal();
  static Database? _db;
  static final String tableName = "anuncio_loja";

  AnuncioHelper.internal();

  factory AnuncioHelper() {
    return _anuncioHelper;
  }

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  _onCreateDb(Database db, int version) {

    String sql = """
        CREATE TABLE anuncio_loja(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emailUser VARCHAR(20) NOT NULL,
        state VARCHAR(10) NOT NULL,
        category VARCHAR(15) NOT NULL,
        title VARCHAR(25) NOT NULL,
        price VARCHAR(15) NOT NULL,
        telephone VARCHAR(20) NOT NULL,
        description TEXT NOT NULL
    );
    """;

    db.execute(sql);

  }

  initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "anuncio_loja.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb
    );

    return db;
  }

  Future<int> insertAnuncio(Anuncio anuncio) async{
    var database = await db;

    int result = await database.insert(tableName, anuncio.toMap());

    return result;

  }

  getAnuncios() async {
    var database = await db;

    String sql = "SELECT * FROM $tableName ORDER BY title DESC";
    List anuncios = await database!.rawQuery(sql);

    return anuncios;
  }
  

  Future<int> deleteAnuncio(int id) async {
    var database = await db;

    int result = await database!.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id]
    );

    return result;
  }

  Future<int> updateAnuncio(Anuncio anuncio) async {
    var database = await db;

    int result = await database!.update(
      tableName,
      anuncio.toMap(),
      where: "id = ?",
      whereArgs: [anuncio.id]
    );

    return result;
  }
}