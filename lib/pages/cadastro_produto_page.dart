import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../providers/produto_provider.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final nomeController = TextEditingController();
  final categoriaController = TextEditingController();
  final quantidadeController = TextEditingController();
  final precoController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    categoriaController.dispose();
    quantidadeController.dispose();
    precoController.dispose();
    super.dispose();
  }

  Future<void> cadastrar() async {
    final nome = nomeController.text.trim();
    final categoria = categoriaController.text.trim();
    final quantidade = int.tryParse(quantidadeController.text.trim());
    final preco = double.tryParse(
      precoController.text.trim().replaceAll(',', '.'),
    );

    if (nome.isEmpty ||
        categoria.isEmpty ||
        quantidade == null ||
        quantidade < 0 ||
        preco == null ||
        preco < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os dados corretamente.')),
      );
      return;
    }

    await context.read<ProdutoProvider>().cadastrarProduto(
          Produto(
            nome: nome,
            categoria: categoria,
            quantidade: quantidade,
            preco: preco,
          ),
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto cadastrado com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Produto')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoriaController,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: precoController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Preço',
                    prefixText: 'R\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: cadastrar,
                    child: const Text('CADASTRAR PRODUTO'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
