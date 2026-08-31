class Manutencao {
  final int id;
  final int veiculoId;
  final String tipo;
  final String descricao;
  final String data;
  final int quilometragem;
  final double valor;

  Manutencao({
    required this.id,
    required this.veiculoId,
    required this.tipo,
    required this.descricao,
    required this.data,
    required this.quilometragem,
    required this.valor,
  });

  factory Manutencao.fromJson(Map<String, dynamic> json) {
    return Manutencao(
      id: json['id'] ?? 0,
      veiculoId: json['veiculo_id'] ?? 0,
      tipo: json['tipo'] ?? '',
      descricao: json['descricao'] ?? '',
      data: json['data_manutencao'] ?? '',
      quilometragem: json['quilometragem'] ?? 0,
      valor: (json['valor'] ?? 0).toDouble(),
    );
  }
}
