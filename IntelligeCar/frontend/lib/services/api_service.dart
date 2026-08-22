import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/veiculo.dart';
import '../models/usuario.dart';
import '../models/manutencao.dart';
import '../models/documento.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<List<Veiculo>> listarVeiculos() async {
    final response = await http.get(Uri.parse('$baseUrl/veiculos'));
    _check(response);
    return (jsonDecode(response.body) as List)
        .map((item) => Veiculo.fromJson(item))
        .toList();
  }

  Future<List<Veiculo>> buscarVeiculos({
    String? marca,
    String? modelo,
    String ordem = 'modelo_asc',
  }) async {
    final params = <String, String>{'ordem': ordem};
    if (marca != null && marca.isNotEmpty) params['marca'] = marca;
    if (modelo != null && modelo.isNotEmpty) params['modelo'] = modelo;
    final uri = Uri.parse('$baseUrl/veiculos/busca').replace(queryParameters: params);
    final response = await http.get(uri);
    _check(response);
    return (jsonDecode(response.body) as List)
        .map((item) => Veiculo.fromJson(item))
        .toList();
  }

  Future<Veiculo> criarVeiculo(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/veiculos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    _check(response);
    return Veiculo.fromJson(jsonDecode(response.body));
  }

  Future<void> atualizarVeiculo(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/veiculos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    _check(response);
  }

  Future<void> deletarVeiculo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/veiculos/$id'));
    _check(response);
  }

  Future<Usuario> criarUsuario(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    _check(response);
    return Usuario.fromJson(jsonDecode(response.body));
  }

  Future<List<Usuario>> listarUsuarios() async {
    final response = await http.get(Uri.parse('$baseUrl/usuarios'));
    _check(response);
    return (jsonDecode(response.body) as List)
        .map((item) => Usuario.fromJson(item))
        .toList();
  }

  Future<List<Manutencao>> historicoManutencoes(int veiculoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/veiculos/$veiculoId/manutencoes'),
    );
    _check(response);
    return (jsonDecode(response.body) as List)
        .map((item) => Manutencao.fromJson(item))
        .toList();
  }

  Future<List<Documento>> proximosVencimentos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/documentos/proximos-vencimentos'),
    );
    _check(response);
    return (jsonDecode(response.body) as List)
        .map((item) => Documento.fromJson(item))
        .toList();
  }

  void _check(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Não foi possível concluir a solicitação.';
      try {
        final data = jsonDecode(response.body);
        if (data['error'] != null) message = data['error'];
      } catch (_) {}
      throw Exception(message);
    }
  }
}
