import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../providers/produto_provider.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProdutoProvider>();
      provider.carregarProdutos();
    });
  }

  String formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProdutoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ESTOQUE'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: provider.carregando
                ? null
                : () => provider.carregarProdutos(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: provider.carregando && provider.produtos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : provider.produtos.isEmpty
              ? const Center(child: Text('Nenhum produto cadastrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.produtos.length,
                  itemBuilder: (context, index) {
                    final produto = provider.produtos[index];
                    return _ProdutoCard(
                      produto: produto,
                      formatarPreco: formatarPreco,
                    );
                  },
                ),
    );
  }
}

class _ProdutoCard extends StatelessWidget {
  final Produto produto;
  final String Function(double) formatarPreco;

  const _ProdutoCard({
    required this.produto,
    required this.formatarPreco,
  });

  @override
  Widget build(BuildContext context) {
    final baixoEstoque = produto.quantidade <= 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.nome,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(produto.categoria),
            const SizedBox(height: 8),
            Text(formatarPreco(produto.preco)),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: produto.quantidade > 0
                      ? () {
                          context.read<ProdutoProvider>().alterarQuantidade(
                                produto,
                                produto.quantidade - 1,
                              );
                        }
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  'Quantidade: ${produto.quantidade}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ProdutoProvider>().alterarQuantidade(
                          produto,
                          produto.quantidade + 1,
                        );
                  },
                  icon: const Icon(Icons.add),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Excluir',
                  onPressed: () => _confirmarExclusao(context),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            if (baixoEstoque)
              const Text(
                'ESTOQUE BAIXO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto?'),
          content: Text('Deseja excluir "${produto.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && context.mounted) {
      await context.read<ProdutoProvider>().excluirProduto(produto);
    }
  }
}
