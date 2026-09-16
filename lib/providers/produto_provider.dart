import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<Produto> produtos = [];
  bool carregando = false;

  Future<void> carregarProdutos() async {
    carregando = true;
    notifyListeners();

    produtos = await _service.listarProdutos();

    carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarProduto(Produto produto) async {
    await _service.cadastrarProduto(produto);
    await carregarProdutos();
  }

  Future<void> alterarQuantidade(Produto produto, int novaQuantidade) async {
    if (novaQuantidade < 0 || produto.id == null) return;

    await _service.atualizarQuantidade(
      produto.id!,
      produto.nome,
      produto.quantidade,
      novaQuantidade,
    );

    await carregarProdutos();
  }

  Future<void> excluirProduto(Produto produto) async {
    if (produto.id == null) return;

    await _service.excluirProduto(produto.id!, produto.nome);
    await carregarProdutos();
  }

  Future<void> mostrarProdutosNoTerminal() async {
    await _service.mostrarProdutosNoTerminal();
  }
}
