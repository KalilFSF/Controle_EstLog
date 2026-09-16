import 'package:sqflite/sqflite.dart';

class BancoService {
  static final BancoService instance = BancoService._internal();

  BancoService._internal();

  Database? _banco;

  Future<Database> get banco async {
    if (_banco != null) return _banco!;

    _banco = await openDatabase(
      'controle_estoque.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE produtos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            categoria TEXT NOT NULL,
            quantidade INTEGER NOT NULL,
            preco REAL NOT NULL
          )
        ''');
      },
    );

    return _banco!;
  }

  Future<void> mostrarProdutosNoTerminal() async {
    final db = await banco;
    final produtos = await db.query('produtos');

    print('===== PRODUTOS NO BANCO =====');
    for (final produto in produtos) {
      print(produto);
    }
  }
}
