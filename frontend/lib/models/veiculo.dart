class Veiculo {
  final int id;
  final int usuarioId;
  final String marca;
  final String modelo;
  final int ano;
  final String placa;
  final int quilometragem;

  Veiculo({
    required this.id,
    required this.usuarioId,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.quilometragem,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      id: json['id'] ?? 0,
      usuarioId: json['usuario_id'] ?? 0,
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      ano: json['ano'] ?? 0,
      placa: json['placa'] ?? '',
      quilometragem: json['quilometragem'] ?? 0,
    );
  }
}
