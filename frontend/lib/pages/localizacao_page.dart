import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';


void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => const MeuAplicativo(),
  ),
);


class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      home: const TelaOficinas(),
    );
  }
}


class TelaOficinas extends StatelessWidget {
  const TelaOficinas({super.key});


  @override
  Widget build(BuildContext context) {
    const azulEscuro = Color(0xFF1B3D6D);
    const cinzaCard = Color(0xFFD9D9D9);


    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Fundo simulando a borda externa externa
      appBar: AppBar(
        backgroundColor: azulEscuro,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Encontrar Oficinas Próximas', style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        actions: const [
          Icon(Icons.wifi, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: Colors.white, // Fundo interno do app
        child: Column(
          children: [
            // Container do Mapa Superior
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4A80CE), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://unsplash.com', // Imagem simulando visual de mapa técnico/textura urbana
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.map, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),


            // Lista de Oficinas Rolável
            Expanded(
              child: Scrollbar(
                thumbVisibility: true, // Mostra a barra de rolagem igual ao design enviado
                thickness: 6,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 8, // Quantidade de oficinas na lista simulada
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: cinzaCard,
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Informações de texto da Oficina
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Web Motors:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'R. catete ....',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          // Sistema de Avaliação por Estrelas (5 estrelas amarelas)
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
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
          ],
        ),
      ),
    );
  }
}