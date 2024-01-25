import 'registros.dart';
import 'dart:io';
import 'dart:async';
import 'package:primera_aplicacion/db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si no hay una instancia de la base de datos, crea una nueva
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // Obtén la ruta del directorio de documentos de la aplicación en el dispositivo
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'registros.db');

    // Abre o crea la base de datos en el directorio de documentos
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE registros(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        dia_ingreso TEXT,
        hora_entrada TEXT,
        hora_salida TEXT,
        hora_comida TEXT,
        observaciones TEXT
      )
    ''');
  }

  Future<int> insertRegistro(Map<String, dynamic> registro) async {
    Database db = await database;
    return await db.insert('registros', registro);
  }

  Future<List<Map<String, dynamic>>> getRegistros() async {
    Database db = await database;
    return await db.query('registros');
  }

  Future<int> updateRegistro(Map<String, dynamic> registro) async {
    Database db = await database;
    return await db.update('registros', registro,
        where: 'id = ?', whereArgs: [registro['id']]);
  }

  Future<int> deleteRegistro(int id) async {
    Database db = await database;
    return await db.delete('registros', where: 'id = ?', whereArgs: [id]);
  }
}
