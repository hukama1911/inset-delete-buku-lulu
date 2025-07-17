
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sq_lite_project/model/model_buku.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _database;
  DatabaseHelper._instance();
  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  //init database
  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'db_buku');
    return await openDatabase(path, version: 1, onCreate: _oncreate);
  }

  //proses untuk buat tabel
  Future _oncreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tb_buku(
        id INTEGER PRIMARY KEY,
        judulbuku TEXT,
        kategory TEXT
      )
    ''');
  }

  //insert data
  Future<int> insertData(ModelBuku buku) async {
    Database db = await instance.db;
    return await db.insert('tb_buku', buku.toMap());
  }

  //get data
  Future<List<Map<String, dynamic>>> quaryAllBuku() async {
    Database db = await instance.db;
    return await db.query('tb_buku');
  }

  //update data
  Future<int> updateBuku(ModelBuku buku) async {
    Database db = await instance.db;
    return await db.update(
      'tb_buku',
      buku.toMap(),
      where: 'id = ?',
      whereArgs: [buku.id],
    );
  }

  //delete data
  Future<int> deleteBuku(int id) async {
    Database db = await instance.db;
    return await db.delete('tb_buku', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> dummyBuku() async {
    List<ModelBuku> dataBukuToAdd = [
      ModelBuku(judulbuku: 'Hii Miko', kategory: 'Komik'),
      ModelBuku(judulbuku: 'Scrambled1', kategory: 'Komik'),
      ModelBuku(judulbuku: 'Raden Ajeng Kartini', kategory: 'Novel'),
      ModelBuku(judulbuku: 'Untukmu Anak Bungsu', kategory: 'Psikologi'),
      ModelBuku(judulbuku: 'Hidup Ini Terlalu Banyak Kamu', kategory: 'Novel'),
    ];
    for (ModelBuku modelBuku in dataBukuToAdd) {
      await insertData(modelBuku);
    }
  }
}
