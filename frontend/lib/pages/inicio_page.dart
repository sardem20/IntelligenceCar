import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => const MeuAplicativo(),
      ),
    );

// 1. MODELO DE DADOS ALINHADO COM A API FLASK
class VeiculoModel {
  final int? id;
  final int usuarioId;
  final String marca;
  final String modelo;
  final int ano;
  final String placa;
  final int quilometragem;
  final String? urlImagem;
  final String? ultimaRevisao;
  final List<String> proximasManutencoes;

  VeiculoModel({
    this.id,
    required this.usuarioId,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.quilometragem,
    this.urlImagem,
    this.ultimaRevisao,
    this.proximasManutencoes = const [],
  });

  // Converte o JSON vindo do Flask
  factory VeiculoModel.fromJson(Map<String, dynamic> json) {
    return VeiculoModel(
      id: json['id'],
      usuarioId: json['usuario_id'] ?? 0,
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      ano: json['ano'] ?? DateTime.now().year,
      placa: json['placa'] ?? '',
      quilometragem: json['quilometragem'] ?? 0,
      urlImagem: json['url_imagem'] ??
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=500',
      ultimaRevisao: json['ultima_revisao'] ?? 'Não informada',
      proximasManutencoes: List<String>.from(json['proximas_manutencoes'] ?? []),
    );
  }

  // Prepara o JSON nos parâmetros esperados pelo Flask (POST /veiculos)
  Map<String, dynamic> toJsonPost() {
    return {
      'usuario_id': usuarioId,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
      'quilometragem': quilometragem,
    };
  }
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      home: const TelaVeiculo(),
    );
  }
}

class TelaVeiculo extends StatefulWidget {
  const TelaVeiculo({super.key});

  @override
  State<TelaVeiculo> createState() => _TelaVeiculoState();
}

class _TelaVeiculoState extends State<TelaVeiculo> {
  VeiculoModel? veiculo;
  bool carregando = false;

  // Em emuladores Android use 'http://127.0.0.1:5000/veiculos'
  // Para Web/Desktop/Dispositivo físico use seu IP local ou domínio
  final String apiUrl = 'http://127.0.0.1:5000/veiculos';

  @override
  void initState() {
    super.initState();
    _carregarDadosDoBackend();
  }

  // Busca lista de veículos do Flask (GET /veiculos)
  Future<void> _carregarDadosDoBackend() async {
    setState(() => carregando = true);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> lista = jsonDecode(response.body);
        if (lista.isNotEmpty) {
          setState(() {
            // Pega o primeiro veículo retornado
            veiculo = VeiculoModel.fromJson(lista.first);
          });
        }
      }
    } catch (e) {
      _mostrarSnackBar('Erro de conexão com o servidor: $e');
    } finally {
      setState(() => carregando = false);
    }
  }

  // Envia POST /veiculos para cadastrar
  Future<void> _cadastrarVeiculoNoBackend(VeiculoModel novoVeiculo) async {
    setState(() => carregando = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(novoVeiculo.toJsonPost()),
      );

      if (response.statusCode == 201) {
        final dadosRetornados = jsonDecode(response.body);
        setState(() {
          veiculo = VeiculoModel.fromJson(dadosRetornados);
        });
        _mostrarSnackBar('Veículo cadastrado com sucesso!');
      } else {
        final erro = jsonDecode(response.body);
        _mostrarSnackBar('Erro (${response.statusCode}): ${erro["error"]}');
      }
    } catch (e) {
      _mostrarSnackBar('Falha na comunicação com a API: $e');
    } finally {
      setState(() => carregando = false);
    }
  }

  // Formulário alinhado aos campos exigidos pela API Flask
  void _exibirDialogoCadastro() {
    final formKey = GlobalKey<FormState>();
    final marcaController = TextEditingController();
    final modeloController = TextEditingController();
    final anoController = TextEditingController();
    final placaController = TextEditingController();
    final kmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastrar Veículo'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: marcaController,
                    decoration: const InputDecoration(labelText: 'Marca (ex: Peugeot)'),
                    validator: (v) => v == null || v.isEmpty ? 'Informe a marca' : null,
                  ),
                  TextFormField(
                    controller: modeloController,
                    decoration: const InputDecoration(labelText: 'Modelo (ex: 308 THP)'),
                    validator: (v) => v == null || v.isEmpty ? 'Informe o modelo' : null,
                  ),
                  TextFormField(
                    controller: anoController,
                    decoration: const InputDecoration(labelText: 'Ano (ex: 2013)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Informe o ano' : null,
                  ),
                  TextFormField(
                    controller: placaController,
                    decoration: const InputDecoration(labelText: 'Placa (ex: LLW-9B98)'),
                    validator: (v) => v == null || v.isEmpty ? 'Informe a placa' : null,
                  ),
                  TextFormField(
                    controller: kmController,
                    decoration: const InputDecoration(labelText: 'Quilometragem'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Informe a quilometragem' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final novoVeiculo = VeiculoModel(
                    usuarioId: 1,
                    marca: marcaController.text,
                    modelo: modeloController.text,
                    ano: int.parse(anoController.text),
                    placa: placaController.text,
                    quilometragem: int.parse(kmController.text),
                  );

                  Navigator.pop(context);
                  _cadastrarVeiculoNoBackend(novoVeiculo);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const azulEscuro = Color(0xFF1B3D6D);
    const azulBotao = Color(0xFF4A80CE);
    const cinzaCard = Color(0xFFD9D9D9);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: azulEscuro,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Seu Veículo', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: const [
          Icon(Icons.wifi, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: carregando
            ? const Center(
                child: CircularProgressIndicator(color: azulEscuro),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // ESTADO 1: Sem veículo cadastrado
                    if (veiculo == null) ...[
                      const SizedBox(height: 60),
                      const Icon(
                        Icons.directions_car_filled_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum veículo cadastrado',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Toque no botão abaixo para adicionar as informações do seu carro.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 120),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: azulBotao),
                        onPressed: _exibirDialogoCadastro,
                        child: const Text(
                          'Cadastrar Novo Veículo 🚘',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],

                    // ESTADO 2: Com veículo retornado do backend
                    if (veiculo != null) ...[
                      Text(
                        '${veiculo!.marca} ${veiculo!.modelo} (${veiculo!.ano})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Placa: ${veiculo!.placa}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: azulEscuro,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            veiculo!.urlImagem ?? '',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 150,
                              color: cinzaCard,
                              child: const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'KM Atual: ${veiculo!.quilometragem} km\nÚltima revisão: ${veiculo!.ultimaRevisao}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: azulBotao,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Registrar\nmanutenção',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cinzaCard,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Ver Histórico',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cinzaCard,
                          minimumSize: const Size.fromHeight(45),
                        ),
                        onPressed: () {},
                        icon: const Text('📅'),
                        label: const Text(
                          'Encontrar Manutenção:',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: azulEscuro, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Próximas manutenções ⚠️',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (veiculo!.proximasManutencoes.isEmpty)
                              const Text(
                                'Nenhuma manutenção pendente.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ...veiculo!.proximasManutencoes
                                .map(
                                  (item) => Text(
                                    '• $item',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                )
                                ,
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cinzaCard,
                          minimumSize: const Size.fromHeight(45),
                        ),
                        onPressed: () {},
                        icon: const Text('📍'),
                        label: const Text(
                          'Encontrar oficinas próximas:',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}