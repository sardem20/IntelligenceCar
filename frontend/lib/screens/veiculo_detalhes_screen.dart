import 'package:flutter/material.dart';
import '../models/manutencao.dart';
import '../models/veiculo.dart';
import '../services/api_service.dart';
import '../widgets/app_card.dart';

class VeiculoDetalhesScreen extends StatelessWidget {
  final ApiService api;
  final Veiculo veiculo;

  const VeiculoDetalhesScreen({super.key, required this.api, required this.veiculo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do veículo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.directions_car, size: 48),
                const SizedBox(height: 14),
                Text('${veiculo.marca} ${veiculo.modelo}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${veiculo.ano} • ${veiculo.placa}'),
                Text('${veiculo.quilometragem} km'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text('Histórico de manutenção', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          FutureBuilder<List<Manutencao>>(
            future: api.historicoManutencoes(veiculo.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return const AppCard(child: Text('Não foi possível carregar o histórico.'));
              }
              final lista = snapshot.data ?? [];
              if (lista.isEmpty) return const AppCard(child: Text('Nenhuma manutenção registrada para este veículo.'));
              return Column(
                children: lista.map((item) {
                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.build_circle_outlined),
                            const SizedBox(width: 10),
                            Expanded(child: Text(item.tipo, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                            Text('R\$ ${item.valor.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (item.descricao.isNotEmpty) Text(item.descricao),
                        const SizedBox(height: 6),
                        Text('${item.data} • ${item.quilometragem} km', style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
