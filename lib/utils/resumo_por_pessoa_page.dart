import 'package:flutter/material.dart';
import '../models/shop.dart';

class ResumoPorPessoaPage extends StatelessWidget {
  final List<Shop> shopping;

  const ResumoPorPessoaPage({
    super.key,
    required this.shopping,
  });

  Map<String, double> _calcularTotais() {
    final Map<String, double> totais = {};

    for (final shop in shopping) {
      final valor = double.tryParse(shop.title) ?? 0;

      totais.update(
        shop.pessoa,
        (v) => v + valor,
        ifAbsent: () => valor,
      );
    }

    return totais;
  }

  @override
  Widget build(BuildContext context) {
    final totais = _calcularTotais();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo por Pessoa'),
      ),
      body: totais.isEmpty
          ? const Center(child: Text('Nenhum gasto registrado'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: totais.entries.map((entry) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(entry.key),
                    trailing: Text(
                      'R\$ ${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
