import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../models/veiculo.dart';
import '../services/api_service.dart';
import '../widgets/app_card.dart';
//import 'veiculos_screen.dart';

class HomeScreen extends StatefulWidget {
  final ApiService api;
  const HomeScreen({super.key, required this.api});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Veiculo>> _veiculos;
  late Future<List<Documento>> _documentos;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _veiculos = widget.api.listarVeiculos();
    _documentos = widget.api.proximosVencimentos();
  }

  Future<void> _atualizar() async {
    setState(_carregar);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _atualizar,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          const Text('Olá!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Veja como estão seus veículos hoje.', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          FutureBuilder<List<Veiculo>>(
            future: _veiculos,
            builder: (context, snapshot) {
              final total = snapshot.data?.length ?? 0;
              return Row(
                children: [
                  Expanded(child: _metric('Veículos', '$total', Icons.directions_car_outlined)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FutureBuilder<List<Documento>>(
                      future: _documentos,
                      builder: (context, documentSnapshot) {
                        final totalDocs = documentSnapshot.data?.length ?? 0;
                        return _metric('Vencimentos', '$totalDocs', Icons.event_note_outlined);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const Text('Documentos próximos do vencimento', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          FutureBuilder<List<Documento>>(
            future: _documentos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) return AppCard(child: Text('Não foi possível carregar os documentos.'));
              if (snapshot.data!.isEmpty) {
                return const AppCard(child: Text('Nenhum documento vence nos próximos 30 dias.'));
              }
              return Column(
                children: snapshot.data!.take(5).map((doc) {
                  return AppCard(
                    child: Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.description_outlined)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.tipo, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${doc.marca} ${doc.modelo} • ${doc.placa}', style: TextStyle(color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text('Vence em ${doc.diasParaVencer} dias', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
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

  Widget _metric(String title, String value, IconData icon) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
