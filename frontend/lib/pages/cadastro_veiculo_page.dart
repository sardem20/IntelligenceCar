import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import './inicio_page.dart';

void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => const MaterialApp(
      useInheritedMediaQuery: true,
      home: TelaCadastro(),
    ),
  ),
);


class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3D6D),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('CADASTRO DO VEÍCULO', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [Icon(Icons.wifi, color: Colors.white), SizedBox(width: 16)],
      ),
      body: Container(
        color: Colors.white, // Fundo interno
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'PLACA',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const SizedBox(height: 30),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'MODELO',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const SizedBox(height: 30),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'MARCA',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const SizedBox(height: 30),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'ANO',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const SizedBox(height: 30),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'TIPO E MOTOR',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const SizedBox(height: 30),
            const TextField(
                      decoration: InputDecoration(
                        hintText: 'KM ATUAL',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D86E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A80CE),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MeuAplicativo()),
                        );
                },
                child: const Text('CADASTRAR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
