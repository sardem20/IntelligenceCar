import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/veiculo.dart';
import '../services/api_service.dart';

class VeiculoFormScreen extends StatefulWidget {
  final ApiService api;
  final Veiculo? veiculo;

  const VeiculoFormScreen({super.key, required this.api, this.veiculo});

  @override
  State<VeiculoFormScreen> createState() => _VeiculoFormScreenState();
}

class _VeiculoFormScreenState extends State<VeiculoFormScreen> {
  final formKey = GlobalKey<FormState>();
  final marca = TextEditingController();
  final modelo = TextEditingController();
  final ano = TextEditingController();
  final placa = TextEditingController();
  final km = TextEditingController();
  List<Usuario> usuarios = [];
  int? usuarioId;
  bool salvando = false;

  bool get editando => widget.veiculo != null;

  @override
  void initState() {
    super.initState();
    final v = widget.veiculo;
    if (v != null) {
      marca.text = v.marca;
      modelo.text = v.modelo;
      ano.text = v.ano.toString();
      placa.text = v.placa;
      km.text = v.quilometragem.toString();
      usuarioId = v.usuarioId;
    } else {
      km.text = '0';
      _carregarUsuarios();
    }
  }

  Future<void> _carregarUsuarios() async {
    try {
      final lista = await widget.api.listarUsuarios();
      if (mounted) setState(() => usuarios = lista);
    } catch (_) {}
  }

  Future<void> _salvar() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => salvando = true);
    try {
      final data = {
        'marca': marca.text.trim(),
        'modelo': modelo.text.trim(),
        'ano': int.parse(ano.text),
        'placa': placa.text.trim().toUpperCase(),
        'quilometragem': int.parse(km.text),
      };
      if (editando) {
        await widget.api.atualizarVeiculo(widget.veiculo!.id, data);
      } else {
        data['usuario_id'] = usuarioId;
        await widget.api.criarVeiculo(data);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  String? obrigatorio(String? value) => value == null || value.trim().isEmpty ? 'Preencha este campo.' : null;

  @override
  void dispose() {
    marca.dispose();
    modelo.dispose();
    ano.dispose();
    placa.dispose();
    km.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar veículo' : 'Novo veículo')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(controller: marca, decoration: const InputDecoration(labelText: 'Marca'), validator: obrigatorio),
            const SizedBox(height: 14),
            TextFormField(controller: modelo, decoration: const InputDecoration(labelText: 'Modelo'), validator: obrigatorio),
            const SizedBox(height: 14),
            TextFormField(controller: ano, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ano'), validator: (v) => int.tryParse(v ?? '') == null ? 'Informe um ano válido.' : null),
            const SizedBox(height: 14),
            TextFormField(controller: placa, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'Placa'), validator: obrigatorio),
            const SizedBox(height: 14),
            TextFormField(controller: km, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quilometragem'), validator: (v) => int.tryParse(v ?? '') == null ? 'Informe a quilometragem.' : null),
            if (!editando) ...[
              const SizedBox(height: 14),
              DropdownButtonFormField<int>(
                value: usuarioId,
                decoration: const InputDecoration(labelText: 'Proprietário'),
                items: usuarios.map((u) => DropdownMenuItem(value: u.id, child: Text(u.nome))).toList(),
                onChanged: (value) => setState(() => usuarioId = value),
                validator: (value) => value == null ? 'Selecione um proprietário.' : null,
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: salvando ? null : _salvar,
                child: salvando ? const CircularProgressIndicator() : Text(editando ? 'Salvar alterações' : 'Cadastrar veículo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
