import 'package:sqflite/sqflite.dart';

import '../models/produto.dart';
import 'banco_service.dart';

class ProdutoService {
  final BancoService _bancoService = BancoService.instance;

  Future<List<Produto>> listarProdutos() async {
    final db = await _bancoService.banco;

    final resultado = await db.query(
      'produtos',
      orderBy: 'id DESC',
    );

    print('SELECT → Produtos encontrados:');
    for (final produto in resultado) {
      print(produto);
    }

    return resultado.map((map) => Produto.fromMap(map)).toList();
  }

  Future<void> cadastrarProduto(Produto produto) async {
    final db = await _bancoService.banco;

    await db.insert('produtos', produto.toMap());
    print('INSERT → Produto cadastrado: ${produto.nome}');
  }

  Future<void> atualizarQuantidade(int id, String nome, int anterior, int nova) async {
    final db = await _bancoService.banco;

    await db.update(
      'produtos',
      {'quantidade': nova},
      where: 'id = ?',
      whereArgs: [id],
    );

    print('UPDATE → $nome');
    print('Quantidade anterior: $anterior');
    print('Nova quantidade: $nova');
  }

  Future<void> excluirProduto(int id, String nome) async {
    final db = await _bancoService.banco;

    await db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );

    print('DELETE → Produto excluído: $nome');
  }

  Future<void> mostrarProdutosNoTerminal() {
    return _bancoService.mostrarProdutosNoTerminal();
  }
}
