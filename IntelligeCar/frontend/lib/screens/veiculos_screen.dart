import 'package:flutter/material.dart';
import '../models/veiculo.dart';
import '../services/api_service.dart';
import '../widgets/app_card.dart';
import 'veiculo_form_screen.dart';
import 'veiculo_detalhes_screen.dart';

class VeiculosScreen extends StatefulWidget {
  final ApiService api;
  const VeiculosScreen({super.key, required this.api});

  @override
  State<VeiculosScreen> createState() => _VeiculosScreenState();
}

class _VeiculosScreenState extends State<VeiculosScreen> {
  late Future<List<Veiculo>> _veiculos;
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  String ordem = 'modelo_asc';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _veiculos = widget.api.buscarVeiculos(
      marca: marcaController.text,
      modelo: modeloController.text,
      ordem: ordem,
    );
  }

  Future<void> _buscar() async {
    setState(_carregar);
  }

  Future<void> _abrirFormulario([Veiculo? veiculo]) async {
    final alterou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VeiculoFormScreen(api: widget.api, veiculo: veiculo),
      ),
    );
    if (alterou == true) setState(_carregar);
  }

  Future<void> _excluir(Veiculo veiculo) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir veículo'),
        content: Text('Deseja excluir ${veiculo.marca} ${veiculo.modelo}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmou != true) return;
    try {
      await widget.api.deletarVeiculo(veiculo.id);
      if (mounted) {
        setState(_carregar);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veículo excluído.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            children: [
              TextField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca', prefixIcon: Icon(Icons.search)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo', prefixIcon: Icon(Icons.directions_car_outlined)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: ordem,
                      decoration: const InputDecoration(labelText: 'Ordenar por'),
                      items: const [
                        DropdownMenuItem(value: 'modelo_asc', child: Text('Modelo')),
                        DropdownMenuItem(value: 'ano_asc', child: Text('Ano crescente')),
                        DropdownMenuItem(value: 'ano_desc', child: Text('Ano decrescente')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            ordem = value;
                            _carregar();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(onPressed: _buscar, child: const Text('Buscar')),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Veiculo>>(
            future: _veiculos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Não foi possível carregar os veículos.\n${snapshot.error}')));
              }
              final veiculos = snapshot.data ?? [];
              if (veiculos.isEmpty) return const Center(child: Text('Nenhum veículo encontrado.'));
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                itemCount: veiculos.length,
                itemBuilder: (context, index) {
                  final veiculo = veiculos[index];
                  return AppCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VeiculoDetalhesScreen(api: widget.api, veiculo: veiculo)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 26, child: Icon(Icons.directions_car)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${veiculo.marca} ${veiculo.modelo}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${veiculo.ano} • ${veiculo.placa}'),
                              Text('${veiculo.quilometragem} km', style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'editar') _abrirFormulario(veiculo);
                            if (value == 'excluir') _excluir(veiculo);
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'editar', child: Text('Editar')),
                            PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
