import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../widgets/app_card.dart';

class UsuariosScreen extends StatefulWidget {
  final ApiService api;
  const UsuariosScreen({super.key, required this.api});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  late Future<List<Usuario>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = widget.api.listarUsuarios();
  }

  void carregar() {
    setState(() => usuarios = widget.api.listarUsuarios());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Row(
            children: [
              const Expanded(child: Text('Usuários', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              FilledButton.icon(
                onPressed: () => _formulario(),
                icon: const Icon(Icons.add),
                label: const Text('Novo'),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Usuario>>(
            future: usuarios,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text('Não foi possível carregar os usuários.'));
              final lista = snapshot.data ?? [];
              if (lista.isEmpty) return const Center(child: Text('Nenhum usuário cadastrado.'));
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                children: lista.map((u) {
                  return AppCard(
                    child: Row(
                      children: [
                        CircleAvatar(child: Text(u.nome.isEmpty ? '?' : u.nome[0].toUpperCase())),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(u.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(u.email, style: TextStyle(color: Colors.grey.shade600)),
                        ])),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _formulario() async {
    final nome = TextEditingController();
    final email = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final criado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo usuário'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: nome, decoration: const InputDecoration(labelText: 'Nome'), validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome.' : null),
              TextFormField(controller: email, decoration: const InputDecoration(labelText: 'E-mail'), validator: (v) => v == null || !v.contains('@') ? 'Informe um e-mail válido.' : null),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await _criarUsuario(nome.text, email.text);
                if (context.mounted) Navigator.pop(context, true);
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
    nome.dispose();
    email.dispose();
    if (criado == true) carregar();
  }

  Future<void> _criarUsuario(String nome, String email) async {
    final response = await widget.api.listarUsuarios();
    if (response.any((u) => u.email.toLowerCase() == email.trim().toLowerCase())) {
      throw Exception('Este e-mail já está cadastrado.');
    }
    final request = await _postUsuario(nome, email);
    if (!request) throw Exception('Não foi possível cadastrar o usuário.');
  }

  Future<bool> _postUsuario(String nome, String email) async {
    try {
      final service = widget.api;
      await service.criarUsuario({'nome': nome, 'email': email});
      return true;
    } catch (_) {
      return false;
    }
  }
}
