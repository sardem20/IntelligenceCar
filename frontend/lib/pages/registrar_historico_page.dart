import 'package:flutter/material.dart';


class TelaRegistrarManutencao extends StatefulWidget {
  final Function(String data, String oficina, String tipo, String km, String desc) aoSalvar;


  const TelaRegistrarManutencao({super.key, required this.aoSalvar});


  @override
  State<TelaRegistrarManutencao> createState() => _TelaRegistrarManutencaoState();
}


class _TelaRegistrarManutencaoState extends State<TelaRegistrarManutencao> {
  String tipoSelecionado = 'Preventiva';
  final _dataController = TextEditingController();
  final _kmController = TextEditingController();
  final _oficinaController = TextEditingController();
  final _descController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    const azulEscuro = Color(0xFF1B3D6D);
    const cinzaCard = Color(0xFFD9D9D9);


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Tipo de Manutenção
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cinzaCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: azulEscuro, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 8.0),
                  child: Text('Tipo:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Row(
                  children: [
                    Radio(
                      value: 'Preventiva',
                      groupValue: tipoSelecionado,
                      activeColor: const Color(0xFF4A80CE),
                      onChanged: (val) => setState(() => tipoSelecionado = val.toString()),
                    ),
                    const Text('Preventiva', style: TextStyle(color: Colors.black)),
                    const SizedBox(width: 16),
                    Radio(
                      value: 'Corretiva',
                      groupValue: tipoSelecionado,
                      activeColor: const Color(0xFF4A80CE),
                      onChanged: (val) => setState(() => tipoSelecionado = val.toString()),
                    ),
                    const Text('Corretiva', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Form do Registro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cinzaCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: azulEscuro, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _campoTexto('Data:', 'Ex: 15/05/2026 (Use dd/mm/aaaa)', _dataController),
                _campoTexto('KM atual:', '[ 000000 km ]', _kmController),
                _campoTexto('Oficina:', '[ nome da oficina ]', _oficinaController),
                _campoTexto('Descrição:', '[ Escreva os detalhes... ]', _descController),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Anexar Nota Fiscal:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 4),
          Container(
            height: 70,
            width: 150,
            decoration: BoxDecoration(color: cinzaCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: azulEscuro, width: 2)),
            child: const Icon(Icons.description_outlined, size: 35, color: Colors.black45),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A80CE),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.black)),
              ),
              onPressed: () {
                if (_dataController.text.length >= 5 && _oficinaController.text.isNotEmpty) {
                  widget.aoSalvar(
                    _dataController.text.trim(),
                    _oficinaController.text.trim(),
                    tipoSelecionado,
                    _kmController.text.trim(),
                    _descController.text.trim(),
                  );
                  _dataController.clear();
                  _kmController.clear();
                  _oficinaController.clear();
                  _descController.clear();
                }
              },
              child: const Text('SALVAR MANUTENÇÃO', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }


  Widget _campoTexto(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.black45, fontSize: 12), border: InputBorder.none, isDense: true),
          ),
        ],
      ),
    );
  }
}