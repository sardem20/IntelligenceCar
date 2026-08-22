class Documento {
  final int id;
  final int veiculoId;
  final String tipo;
  final String dataValidade;
  final int diasParaVencer;
  final String marca;
  final String modelo;
  final String placa;

  Documento({
    required this.id,
    required this.veiculoId,
    required this.tipo,
    required this.dataValidade,
    required this.diasParaVencer,
    required this.marca,
    required this.modelo,
    required this.placa,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'] ?? 0,
      veiculoId: json['veiculo_id'] ?? 0,
      tipo: json['tipo'] ?? '',
      dataValidade: json['data_validade'] ?? '',
      diasParaVencer: json['dias_para_vencer'] ?? 0,
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      placa: json['placa'] ?? '',
    );
  }
}
