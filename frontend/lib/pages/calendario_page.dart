import 'package:flutter/material.dart';


class TelaCalendario extends StatefulWidget {
  final Map<String, dynamic> agendaManutencoes;
  final String dataFoco;


  const TelaCalendario({super.key, required this.agendaManutencoes, required this.dataFoco});


  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}


class _TelaCalendarioState extends State<TelaCalendario> {
  late String dataSelecionada;


  final List<Map<String, dynamic>> mesesDados = [
    {"nome": "janeiro 2026", "mesNum": 1, "dias": 31, "offset": 3},
    {"nome": "fevereiro 2026", "mesNum": 2, "dias": 28, "offset": 6},
    {"nome": "maio 2026", "mesNum": 5, "dias": 31, "offset": 4},
    {"nome": "junho 2026", "mesNum": 6, "dias": 30, "offset": 0},
    {"nome": "setembro 2026", "mesNum": 9, "dias": 30, "offset": 1},
    {"nome": "outubro 2026", "mesNum": 10, "dias": 31, "offset": 3},
  ];


  @override
  void initState() {
    super.initState();
    dataSelecionada = widget.dataFoco;
  }


  @override
  Widget build(BuildContext context) {
    const azulEscuro = Color(0xFF1B3D6D);
    const cinzaCard = Color(0xFFD9D9D9);


    final String chaveBusca = dataSelecionada.length >= 5 ? dataSelecionada.substring(0, 5) : "";
    final manutencaoAtual = widget.agendaManutencoes[chaveBusca];


    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: azulEscuro, borderRadius: BorderRadius.circular(20)),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85,
              ),
              itemCount: mesesDados.length,
              itemBuilder: (context, index) => _buildMesCard(mesesDados[index]),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cinzaCard, border: Border.all(color: azulEscuro, width: 2.5), borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(dataSelecionada, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              if (manutencaoAtual != null) ...[
                Text('${manutencaoAtual['local']} (${manutencaoAtual['tipo']})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                Text('Quilometragem: ${manutencaoAtual['km']}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text('• ${manutencaoAtual['desc']}', style: const TextStyle(color: Colors.black87, fontSize: 13)),
              ] else ...[
                const Text('Nenhum registro encontrado para este dia.', style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildMesCard(Map<String, dynamic> mes) {
    final int totalDias = mes['dias'];
    final int offset = mes['offset'];
    final int mesNum = mes['mesNum'];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF4A80CE),
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(mes['nome'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemCount: totalDias + offset,
              itemBuilder: (context, index) {
                if (index < offset) return const SizedBox();
                
                final int dia = index - offset + 1;
                final String diaStr = dia.toString().padLeft(2, '0');
                final String mesStr = mesNum.toString().padLeft(2, '0');
                final String chaveDia = "$diaStr/$mesStr";
                
                final bool temDados = widget.agendaManutencoes.containsKey(chaveDia);
                final bool selecionado = dataSelecionada.startsWith(chaveDia);

                Color corTexto = Colors.black;
                BoxDecoration? decoracao;

                if (temDados) corTexto = Colors.red;
                if (selecionado) {
                  decoracao = BoxDecoration(color: Colors.amber.withOpacity(0.5), shape: BoxShape.circle);
                }

                return GestureDetector(
                  onTap: () => setState(() => dataSelecionada = "$chaveDia/2026"),
                  child: Container(
                    decoration: decoracao,
                    alignment: Alignment.center,
                    child: Text('$dia', style: TextStyle(fontSize: 9, fontWeight: temDados ? FontWeight.bold : FontWeight.normal, color: corTexto)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}