import 'package:flutter/material.dart';


class TelaHistorico extends StatelessWidget {
  const TelaHistorico({super.key});


  @override
  Widget build(BuildContext context) {
    const azulEscuro = Color(0xFF1B3D6D);
    const cinzaCard = Color(0xFFD9D9D9);


    // Lista simulada com os dados exatamente iguais aos da sua imagem
    final List<Map<String, String>> itensHistorico = [
      {'tipo': 'Preventiva', 'data': '12/12/2025', 'desc': 'Troca de óleo + filtro', 'oficina': 'Via Lube'},
      {'tipo': 'Corretiva', 'data': '12/12/2025', 'desc': 'Troca de óleo + filtro', 'oficina': 'Via Lube', 'destaque': 'sim'},
      {'tipo': 'Corretiva', 'data': '12/12/2025', 'desc': 'Troca de óleo + filtro', 'oficina': 'Via Lube'},
      {'tipo': 'Preventiva', 'data': '12/12/2025', 'desc': 'Troca de óleo + filtro', 'oficina': 'Via Lube'},
      {'tipo': 'Preventiva', 'data': '12/12/2025', 'desc': 'Troca de óleo + filtro', 'oficina': 'Via Lube'},
    ];


    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Borda externa do dispositivo
      appBar: AppBar(
        backgroundColor: azulEscuro,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Histórico', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Icon(Icons.wifi, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: Colors.white, // Fundo interno branco
        child: Scrollbar(
          thumbVisibility: true, // Barra de rolagem lateral igual à imagem
          thickness: 6,
          radius: const Radius.circular(10),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            itemCount: itensHistorico.length,
            itemBuilder: (context, index) {
              final item = itensHistorico[index];
              final bool temDestaque = item['destaque'] == 'sim';


              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Stack(
                  children: [
                    // Card Principal Cinza
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      decoration: BoxDecoration(
                        color: cinzaCard,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          // O segundo item tem uma borda azul de seleção em destaque
                          color: temDestaque ? const Color(0xFF4A80CE) : azulEscuro,
                          width: temDestaque ? 2.5 : 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['data']!, style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text('Preventiva', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7))),
                          Text(item['desc']!, style: const TextStyle(fontSize: 14, color: Colors.black)),
                          Text('Oficina: ${item['oficina']}', style: const TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ),
                    
                    // Etiqueta Superior (Preventiva / Corretiva)
                    Positioned(
                      top: -12,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        decoration: BoxDecoration(
                          color: azulEscuro,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['tipo']!,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}